import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/feature_tile.dart';
import '../../shared/widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.grid_view_rounded, color: AppTheme.background, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppConstants.appName, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
                  Text('مجتمع ماينكرافت Bedrock', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded), tooltip: 'الإشعارات'),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF214B42), Color(0xFF172A35)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.accent.withValues(alpha: 0.25)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('أهلاً بك بالمجتمع', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              SizedBox(height: 8),
              Text('مكانك لمتابعة ملفك، إنجازاتك، أخبار السيرفر والفعاليات.', style: TextStyle(color: Colors.white70, height: 1.5)),
              SizedBox(height: 18),
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: Colors.amber),
                  SizedBox(width: 8),
                  Expanded(child: Text('اتصال السيرفر غير مربوط بعد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: 'الوصول السريع'),
        const SizedBox(height: 10),
        const FeatureTile(icon: Icons.person_search_outlined, title: 'ملف اللاعب', subtitle: 'الرتبة والإحصائيات والإنجازات'),
        const SizedBox(height: 10),
        const FeatureTile(icon: Icons.emoji_events_outlined, title: 'لوحة المتصدرين', subtitle: 'ترتيب اللاعبين حسب بيانات السيرفر'),
        const SizedBox(height: 10),
        const FeatureTile(icon: Icons.campaign_outlined, title: 'الأخبار والفعاليات', subtitle: 'إعلانات المجتمع والأحداث القادمة'),
        const SizedBox(height: 24),
        const SectionTitle(title: 'حالة المشروع'),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: const [
                _StatusRow(label: 'واجهة التطبيق', ready: true),
                SizedBox(height: 12),
                _StatusRow(label: 'الحسابات والصلاحيات', ready: false),
                SizedBox(height: 12),
                _StatusRow(label: 'ربط ماينكرافت', ready: false),
                SizedBox(height: 12),
                _StatusRow(label: 'بيانات حقيقية', ready: false),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.ready});
  final String label;
  final bool ready;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(ready ? Icons.check_circle : Icons.pending_outlined, size: 19, color: ready ? AppTheme.accent : AppTheme.muted),
        const SizedBox(width: 10),
        Expanded(child: Text(label)),
        Text(ready ? 'جاهز' : 'لاحقاً', style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
      ],
    );
  }
}
