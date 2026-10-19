import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

void main() => runApp(const ResourcePackStudioApp());

class ResourcePackStudioApp extends StatelessWidget {
  const ResourcePackStudioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Resource Pack Studio',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF55D6A3), brightness: Brightness.dark), useMaterial3: true, scaffoldBackgroundColor: const Color(0xFF101713)),
        home: const StudioHome(),
      );
}

class PackFile {
  PackFile(this.path, this.bytes);
  final String path;
  final Uint8List bytes;
  String get category => categorize(path);
}

String categorize(String path) {
  final p = path.toLowerCase();
  if (p.contains('ui/') || p.contains('ui\\')) return 'واجهة اللعب';
  if (p.contains('sound') || p.contains('audio')) return 'الأصوات';
  if (p.contains('sky') || p.contains('cloud')) return 'السماء';
  if (p.contains('water') || p.contains('underwater')) return 'الماء';
  if (p.contains('item') || p.contains('items')) return 'الأدوات والعناصر';
  if (p.contains('entity') || p.contains('mob') || p.contains('model')) return 'الكائنات';
  if (p.contains('particle')) return 'الجزيئات والتأثيرات';
  if (p.contains('font')) return 'الخطوط';
  if (p.contains('texture') || p.contains('terrain') || p.contains('block') || p.contains('ore')) return 'الخامات والبلوكات';
  if (p.contains('animation')) return 'الحركات';
  return 'ملفات أخرى';
}

class StudioHome extends StatefulWidget {
  const StudioHome({super.key});
  @override
  State<StudioHome> createState() => _StudioHomeState();
}

class _StudioHomeState extends State<StudioHome> {
  final List<PackFile> _files = [];
  final Set<String> _selected = {};
  final Set<String> _selectedCategories = {};
  final Set<String> _filters = {};
  final Map<String, String> _conflictChoice = {};
  String _packName = 'My Custom Pack';
  String _description = 'Custom resource pack made with Resource Pack Studio';
  String _author = '';
  String _version = '1.0.0';
  Uint8List? _iconBytes;
  bool _busy = false;
  String _status = 'استورد باك أو أكثر حتى تبدأ التخصيص.';
  final _uuid = const Uuid();

  Set<String> get _allCategories => _files.map((f) => f.category).toSet();
  List<PackFile> get _visibleFiles => _files.where((f) => _filters.isEmpty || _filters.contains(f.category)).toList();

  Future<void> _importPack() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['mcpack', 'zip'], withData: true, allowMultiple: true);
    if (result == null) return;
    setState(() => _busy = true);
    try {
      var added = 0;
      for (final picked in result.files) {
        final bytes = picked.bytes ?? (picked.path != null ? await File(picked.path!).readAsBytes() : null);
        if (bytes == null) continue;
        final archive = ZipDecoder().decodeBytes(bytes, verify: true);
        for (final entry in archive.files) {
          if (!entry.isFile) continue;
          final path = entry.name.replaceAll('\\', '/');
          if (path.startsWith('/') || path.split('/').contains('..')) continue;
          final content = entry.content;
          if (content is List<int>) {
            final data = Uint8List.fromList(content);
            // Keep a source prefix so importing multiple packs does not silently discard same-path files.
            final source = picked.name.replaceAll(RegExp(r'\.(mcpack|zip)$', caseSensitive: false), '');
            _files.add(PackFile('$source/$path', data));
            added++;
          }
        }
      }
      setState(() => _status = 'تم فهرسة $added ملفاً. راجع التعارضات قبل التصدير.');
    } catch (e) {
      setState(() => _status = 'تعذر قراءة أحد الملفات. تأكد أنه ZIP/MCPACK صالح. التفاصيل: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _pickIcon() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _iconBytes = File(x.path).readAsBytesSync());
  }

  Future<void> _editMetadata() async {
    final name = TextEditingController(text: _packName);
    final desc = TextEditingController(text: _description);
    final author = TextEditingController(text: _author);
    final version = TextEditingController(text: _version);
    final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('معلومات الباك'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم الباك')), TextField(controller: desc, decoration: const InputDecoration(labelText: 'الوصف')), TextField(controller: author, decoration: const InputDecoration(labelText: 'المؤلف')), TextField(controller: version, decoration: const InputDecoration(labelText: 'الإصدار (مثال 1.0.0)'))])),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حفظ'))]));
    if (ok == true) setState(() { _packName = name.text.trim().isEmpty ? 'My Custom Pack' : name.text.trim(); _description = desc.text.trim(); _author = author.text.trim(); _version = version.text.trim().isEmpty ? '1.0.0' : version.text.trim(); });
  }

  Future<void> _exportPack() async {
    if (_files.isEmpty) { setState(() => _status = 'استورد ريسورس باك أولاً.'); return; }
    if (_selected.isEmpty && _selectedCategories.isEmpty) { setState(() => _status = 'حدد الملفات أو التصنيفات التي تريد تضمينها.'); return; }
    setState(() => _busy = true);
    try {
      final chosen = _files.where((f) => _selected.contains(f.path) || _selectedCategories.contains(f.category)).toList();
      final output = <String, Uint8List>{};
      final conflicts = <String, List<PackFile>>{};
      for (final file in chosen) {
        final parts = file.path.split('/');
        // Prefix is the source pack name added during import; remove it for output paths.
        final target = parts.length > 1 ? parts.sublist(1).join('/') : file.path;
        (conflicts[target] ??= []).add(file);
      }
      for (final entry in conflicts.entries) {
        final candidates = entry.value;
        final preferred = _conflictChoice[entry.key];
        final winner = preferred == null ? candidates.last : candidates.firstWhere((f) => f.path.startsWith('$preferred/'), orElse: () => candidates.last);
        output[entry.key] = winner.bytes;
      }
      final manifest = {
        'format_version': 2,
        'header': {'name': _packName, 'description': '${_description}${_author.isEmpty ? '' : '\nAuthor: $_author'}', 'uuid': _uuid.v4(), 'version': _parseVersion(_version), 'min_engine_version': [1, 20, 0]},
        'modules': [{'type': 'resources', 'uuid': _uuid.v4(), 'version': _parseVersion(_version)}]
      };
      output['manifest.json'] = Uint8List.fromList(utf8.encode(const JsonEncoder.withIndent('  ').convert(manifest)));
      if (_iconBytes != null) output['pack_icon.png'] = _iconBytes!;
      final archive = Archive();
      for (final e in output.entries) { archive.addFile(ArchiveFile(e.key, e.value.length, e.value)); }
      final zipped = ZipEncoder().encode(archive);
      if (zipped == null) throw Exception('ZIP encoder returned empty output');
      final dir = await getApplicationDocumentsDirectory();
      final safeName = _packName.replaceAll(RegExp(r'[^a-zA-Z0-9_ -]'), '').trim().replaceAll(' ', '_');
      final file = File('${dir.path}/${safeName.isEmpty ? 'custom_pack' : safeName}.mcpack');
      await file.writeAsBytes(zipped, flush: true);
      setState(() => _status = 'تم إنشاء ${file.path.split('/').last} ويحتوي ${output.length} ملفاً.');
      if (mounted) await showDialog<void>(context: context, builder: (context) => AlertDialog(title: const Text('اكتمل التصدير'), content: Text('تم إنشاء الملف:\n${file.path}\n\nالخطوة التالية: شاركه أو افتحه باستخدام Minecraft. هذا الإصدار لا يضمن سلامة كل باك؛ اختبر النسخة في عالم تجريبي أولاً.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')), TextButton(onPressed: () { Navigator.pop(context); Share.shareXFiles([XFile(file.path, mimeType: 'application/zip')], text: _packName); }, child: const Text('مشاركة')), FilledButton(onPressed: () { Navigator.pop(context); OpenFilex.open(file.path, type: 'application/x-mcpack'); }, child: const Text('فتح في Minecraft'))]));
    } catch (e) {
      setState(() => _status = 'فشل التصدير: $e');
    } finally { setState(() => _busy = false); }
  }

  List<int> _parseVersion(String value) {
    final parts = value.split('.').take(3).map((s) => int.tryParse(s) ?? 0).toList();
    while (parts.length < 3) { parts.add(0); }
    return parts;
  }

  void _toggleFilter(String category, bool enabled) => setState(() { enabled ? _filters.add(category) : _filters.remove(category); });
  void _toggleSelectedCategory(String category, bool enabled) => setState(() { enabled ? _selectedCategories.add(category) : _selectedCategories.remove(category); });

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<PackFile>>{};
    for (final f in _visibleFiles) { (grouped[f.category] ??= []).add(f); }
    return Scaffold(
      appBar: AppBar(title: const Text('Resource Pack Studio'), actions: [IconButton(onPressed: _editMetadata, icon: const Icon(Icons.tune), tooltip: 'معلومات الباك')]),
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 4), child: Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF1B2B24), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF315846))), child: Row(children: [Container(width: 56, height: 56, decoration: BoxDecoration(color: const Color(0xFF263C31), borderRadius: BorderRadius.circular(12), image: _iconBytes == null ? null : DecorationImage(image: MemoryImage(_iconBytes!), fit: BoxFit.cover)), child: _iconBytes == null ? const Icon(Icons.inventory_2_outlined, size: 30) : null), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_packName, style: Theme.of(context).textTheme.titleMedium), Text('${_files.length} ملف مفهرس • ${_selected.length} ملف محدد', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)), Text(_status, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall)])), IconButton(onPressed: _pickIcon, icon: const Icon(Icons.add_photo_alternate_outlined), tooltip: 'صورة الباك')]))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Row(children: [Expanded(child: OutlinedButton.icon(onPressed: _busy ? null : _importPack, icon: const Icon(Icons.add_box_outlined), label: const Text('استيراد MCPACK / ZIP'))), const SizedBox(width: 8), FilledButton.icon(onPressed: _busy ? null : _exportPack, icon: const Icon(Icons.file_download_outlined), label: const Text('تصدير'))])),
        if (_busy) const LinearProgressIndicator(),
        if (_files.isNotEmpty) SizedBox(height: 50, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), children: [Padding(padding: const EdgeInsets.all(4), child: FilterChip(label: const Text('كل التصنيفات'), selected: _filters.isEmpty, onSelected: (_) => setState(() => _filters.clear()))), ..._allCategories.map((c) => Padding(padding: const EdgeInsets.all(4), child: FilterChip(label: Text(c), selected: _filters.contains(c), onSelected: (v) => _toggleFilter(c, v))))])),
        Expanded(child: _files.isEmpty ? Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.layers_outlined, size: 64, color: Color(0xFF55D6A3)), const SizedBox(height: 12), Text('ابدأ بمكتبتك الخاصة', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 8), const Text('استورد ملفات .mcpack أو .zip. ستظهر الملفات هنا لتختار منها حسب التصنيف أو ملفاً ملفاً.', textAlign: TextAlign.center), const SizedBox(height: 14), FilledButton.icon(onPressed: _importPack, icon: const Icon(Icons.add), label: const Text('اختيار باكات من الهاتف'))]))) : ListView(padding: const EdgeInsets.fromLTRB(12, 0, 12, 16), children: grouped.entries.map((group) => Card(color: const Color(0xFF18211C), child: ExpansionTile(title: Text(group.key), subtitle: Text('${group.value.length} ملف'), children: [CheckboxListTile(value: _selectedCategories.contains(group.key), onChanged: (v) => _toggleSelectedCategory(group.key, v == true), title: Text('تضمين التصنيف بالكامل (${group.value.length} ملف)'), controlAffinity: ListTileControlAffinity.leading, dense: true), ...group.value.map((f) => CheckboxListTile(value: _selected.contains(f.path), onChanged: (v) => setState(() => v == true ? _selected.add(f.path) : _selected.remove(f.path)), title: Text(f.path.split('/').last, maxLines: 1, overflow: TextOverflow.ellipsis), subtitle: Text(f.path, maxLines: 1, overflow: TextOverflow.ellipsis), controlAffinity: ListTileControlAffinity.leading, dense: true))].toList())).toList())),
      ])),
    );
  }
}
