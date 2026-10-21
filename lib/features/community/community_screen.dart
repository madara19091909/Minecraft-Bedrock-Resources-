import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/feature_tile.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('المجتمع', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        const Text('مساحة أخبار اللاعبين والفعاليات والتنافس.', style: TextStyle(color: AppTheme.muted)),
        const SizedBox(height: 20),
        const FeatureTile(icon: Icons.leaderboard_outlined, title: 'المتصدرون', subtitle: 'ترتيب مبني على إحصائيات موثوقة'),
        const SizedBox(height: 10),
        const FeatureTile(icon: Icons.newspaper_outlined, title: 'الأخبار والإعلانات', subtitle: 'تحديثات السيرفر والمجتمع'),
        const SizedBox(height: 10),
        const FeatureTile(icon: Icons.event_available_outlined, title: 'الفعاليات', subtitle: 'مواعيد المنافسات والأنشطة'),
        const SizedBox(height: 10),
        const FeatureTile(icon: Icons.groups_2_outlined, title: 'القبائل والفرق', subtitle: 'نضيف نظام الفرق بعد تحديد قواعد السيرفر'),
        const SizedBox(height: 20),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.info_outline, color: AppTheme.accent),
                SizedBox(width: 12),
                Expanded(child: Text('هذه صفحات تأسيسية حالياً. لن نعرض أخباراً أو نتائج وهمية؛ سنربطها بمصدر بيانات فعلي في مرحلة لاحقة.', style: TextStyle(height: 1.5))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
