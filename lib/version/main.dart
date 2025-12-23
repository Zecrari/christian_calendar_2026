import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';
import 'screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check Onboarding Status
  final bool seenOnboarding = await StorageService.hasSeenOnboarding();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(ChristianCalendarApp(startOnboarding: !seenOnboarding));
}

class ChristianCalendarApp extends StatefulWidget {
  final bool startOnboarding;
  const ChristianCalendarApp({Key? key, required this.startOnboarding})
    : super(key: key);

  @override
  State<ChristianCalendarApp> createState() => _ChristianCalendarAppState();
}

class _ChristianCalendarAppState extends State<ChristianCalendarApp> {
  String currentLanguage = AppConstants.ENGLISH;
  ThemeMode themeMode = ThemeMode.light;

  void changeLanguage(String lang) => setState(() => currentLanguage = lang);
  void toggleTheme() => setState(
    () =>
        themeMode =
            themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
  );

  @override
  Widget build(BuildContext context) {
    final Color seedColor = const Color(0xFF673AB7);

    return MaterialApp(
      title: 'Christian Calendar 2026',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
          surface: const Color(0xFFFDFBF7),
          surfaceContainerHighest: const Color(0xFFF3E5F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFFDFBF7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFDFBF7),
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFFFDFBF7),
          indicatorColor: seedColor.withOpacity(0.15),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeMode,
      // LOGIC: If seen onboarding, go to MainNavigation, else OnboardingScreen
      home:
          widget.startOnboarding
              ? const OnboardingScreen()
              : MainNavigation(
                currentLanguage: currentLanguage,
                onLanguageChange: changeLanguage,
                onThemeToggle: toggleTheme,
                themeMode: themeMode,
              ),
    );
  }
}

// ... MainNavigation class remains the same ...
// ... DashboardScreen class remains the same ...
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

// ============================================================================
// DASHBOARD SCREEN (Smooth & Modern)
// ============================================================================
class DashboardScreen extends StatelessWidget {
  final String lang;
  const DashboardScreen({Key? key, required this.lang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final verse = DailyVerses.getVerse(today.day);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Christian Calendar 2026'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. Welcome Card (Gradient)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF673AB7),
                  Color(0xFF512DA8),
                ], // Deep Purple Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppTranslations.get('greeting', lang),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.wb_sunny_rounded,
                      color: Colors.amber,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDate(today),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Verse of the Day
          _buildSectionTitle(
            context,
            AppTranslations.get('verse_of_day', lang),
          ),
          SmoothCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${verse['text']}"',
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      verse['reference']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 4. Quick Actions Grid (Rounded & Colorful)
          _buildSectionTitle(
            context,
            AppTranslations.get('quick_actions', lang),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildQuickAction(
                context,
                Icons.notifications_active_rounded,
                AppTranslations.get('nav_reminders', lang),
                Colors.orange,
                const PrayerRemindersScreen(lang: 'en'),
              ), // Pass lang correctly
              _buildQuickAction(
                context,
                Icons.edit_note_rounded,
                AppTranslations.get('nav_journal', lang),
                Colors.green,
                const PrayerJournalScreen(lang: 'en'),
              ),
              _buildQuickAction(
                context,
                Icons.face_rounded,
                AppTranslations.get('nav_saints', lang),
                Colors.blue,
                const SaintsDevotionalsScreen(lang: 'en'),
              ),
              _buildQuickAction(
                context,
                Icons.volunteer_activism_rounded,
                AppTranslations.get('nav_rosary', lang),
                Colors.pink,
                const RosaryPrayersScreen(lang: 'en'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildTodayEvent(BuildContext context, String dateStr) {
    final event = ChristianEvents.events[dateStr];
    if (event == null) {
      return SmoothCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded, color: Colors.grey.shade400),
              const SizedBox(width: 16),
              Text(
                AppTranslations.get('no_events_today', lang),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    return SmoothCard(
      color: event.color.withOpacity(0.1),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(Icons.celebration_rounded, color: event.color, size: 30),
        title: Text(
          event.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // subtitle: Text(event.scripture),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Widget destinationScreen,
  ) {
    return SmoothCard(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvent(
    BuildContext context,
    String name,
    String date,
    IconData icon,
    Color color,
  ) {
    return SmoothCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
