import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/admin_screen.dart';
import 'features/community/community_screen.dart';
import 'features/home/home_screen.dart';
import 'features/profile/profile_screen.dart';

class CprCommunityApp extends StatelessWidget {
  const CprCommunityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPR Community',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const _pages = <Widget>[
    HomeScreen(),
    ProfileScreen(),
    CommunityScreen(),
    AdminScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'ملفي'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'المجتمع'),
          NavigationDestination(icon: Icon(Icons.admin_panel_settings_outlined), selectedIcon: Icon(Icons.admin_panel_settings), label: 'الإدارة'),
        ],
      ),
    );
  }
}
