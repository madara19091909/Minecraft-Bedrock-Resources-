import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/feature_tile.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('مركز الإدارة', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        const Text('واجهة تجريبية فقط؛ لا توجد أوامر إدارية فعالة حالياً.', style: TextStyle(color: AppTheme.muted, height: 1.5)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFF3B2C1A), borderRadius: BorderRadius.circular(14)),
          child: const Row(children: [
            Icon(Icons.lock_outline, color: Color(0xFFFFC46B)),
            SizedBox(width: 10),
            Expanded(child: Text('ستكون هذه الصفحة متاحة للرتب المخوّلة فقط بعد بناء نظام تسجيل الدخول والصلاحيات.', style: TextStyle(height: 1.4))),
          ]),
        ),
        const SizedBox(height: 20),
        const FeatureTile(icon: Icons.monitor_heart_outlined, title: 'مراقبة السيرفر', subtitle: 'حالة الاتصال واللاعبون المتصلون'),
        const SizedBox(height: 10),
        const FeatureTile(icon: Icons.manage_accounts_outlined, title: 'إدارة اللاعبين', subtitle: 'الرتب والتحذيرات وسجل الإجراءات'),
        const SizedBox(height: 10),
        const FeatureTile(icon: Icons.account_balance_wallet_outlined, title: 'الاقتصاد والمتجر', subtitle: 'الرصيد والأسعار وسجل المعاملات'),
        const SizedBox(height: 10),
        const FeatureTile(icon: Icons.receipt_long_outlined, title: 'السجلات', subtitle: 'أحداث السيرفر وسجل الإدارة'),
      ],
    );
  }
}
