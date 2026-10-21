import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('ملف اللاعب', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        const Text('راح نربط هذا الملف بحساب ماينكرافت بعد تأسيس الحسابات.', style: TextStyle(color: AppTheme.muted, height: 1.5)),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(radius: 38, backgroundColor: AppTheme.surfaceRaised, child: const Icon(Icons.person, size: 42, color: AppTheme.accent)),
                const SizedBox(height: 12),
                const Text('لاعب جديد', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                const Text('الحساب غير مربوط', style: TextStyle(color: AppTheme.muted)),
                const SizedBox(height: 18),
                FilledButton.icon(onPressed: null, icon: const Icon(Icons.link), label: const Text('ربط حساب ماينكرافت')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const _StatGrid(),
        const SizedBox(height: 18),
        const Card(child: ListTile(leading: Icon(Icons.military_tech_outlined), title: Text('الإنجازات'), subtitle: Text('ستظهر إنجازاتك بعد ربط بيانات السيرفر'))),
      ],
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid();

  @override
  Widget build(BuildContext context) {
    const stats = [('المستوى', '—'), ('النقاط', '—'), ('وقت اللعب', '—'), ('الانتصارات', '—')];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.7),
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(stats[index].$1, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
            const SizedBox(height: 7),
            Text(stats[index].$2, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          ]),
        ),
      ),
    );
  }
}
