// Auto-generated file
import 'package:flutter/material.dart';
import '../../config/translations.dart';
import 'dashboard_screen.dart';
import '../calendar/calendar_screen.dart';
import '../bible/bible_reader_screen.dart';
import '../settings/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChange;
  final VoidCallback onThemeToggle;
  final ThemeMode themeMode;

  const MainNavigation({
    Key? key,
    required this.currentLanguage,
    required this.onLanguageChange,
    required this.onThemeToggle,
    required this.themeMode,
  }) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      DashboardScreen(lang: widget.currentLanguage),
      CalendarScreen(lang: widget.currentLanguage),
      BibleReaderScreen(lang: widget.currentLanguage),
      SettingsScreen(
        lang: widget.currentLanguage,
        onLanguageChange: widget.onLanguageChange,
        onThemeToggle: widget.onThemeToggle,
        themeMode: widget.themeMode,
      ),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: NavigationBar(
        height: 70,
        elevation: 0,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.church_outlined),
            selectedIcon: const Icon(
              Icons.church_rounded,
              color: Color(0xFF673AB7),
            ),
            label: AppTranslations.get('nav_home', widget.currentLanguage),
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(
              Icons.calendar_month_rounded,
              color: Color(0xFF673AB7),
            ),
            label: AppTranslations.get('nav_calendar', widget.currentLanguage),
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(
              Icons.menu_book_rounded,
              color: Color(0xFF673AB7),
            ),
            label: AppTranslations.get('nav_bible', widget.currentLanguage),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(
              Icons.settings_rounded,
              color: Color(0xFF673AB7),
            ),
            label: AppTranslations.get('nav_settings', widget.currentLanguage),
          ),
        ],
      ),
    );
  }
}
