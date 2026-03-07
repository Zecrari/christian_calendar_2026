import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'data/storage_service.dart';
import 'screens/home/main_navigation.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'config/theme.dart';
import 'config/constants.dart';
import 'services/ad_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage FIRST
  await StorageService.initialize();

  final bool seenOnboarding = StorageService.hasSeenOnboarding();

  // Initialize Google Ads with test device support
  final InitializationStatus status = await MobileAds.instance.initialize();
  debugPrint('AdMob initialized: ${status.adapterStatuses}');

  // ✅ Set test device IDs so ads load on your device during development.
  // To find YOUR device's test ID: run the app and check logcat for:
  // "Use RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("XXXXXXXX"))"
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ['EMULATOR'], // Add your device hash from logcat here
    ),
  );

  AdHelper.loadInterstitialAd();

  // Date & timezone setup
  await initializeDateFormatting();
  tz.initializeTimeZones();

  // System UI config
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // 🔥 Microsoft Clarity Configuration
  final clarityConfig = ClarityConfig(
    projectId: "vhrji85eoo",
    logLevel: LogLevel.None, 
    // Use LogLevel.Verbose during testing
  );

  runApp(
    ClarityWidget(
      clarityConfig: clarityConfig,
      app: ChristianCalendarApp(startOnboarding: !seenOnboarding),
    ),
  );
}


class ChristianCalendarApp extends StatefulWidget {
  final bool startOnboarding;
  const ChristianCalendarApp({super.key, required this.startOnboarding});

  @override
  State<ChristianCalendarApp> createState() => _ChristianCalendarAppState();
}

class _ChristianCalendarAppState extends State<ChristianCalendarApp> {
  late String currentLanguage;
  late ThemeMode themeMode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // OPTIMIZED: Sync load from cached storage
  void _loadSettings() {
    currentLanguage = StorageService.loadLanguage();
    final isDark = StorageService.loadTheme();
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    setState(() => _isLoading = false);
  }

  void changeLanguage(String lang) {
    if (lang == currentLanguage) return;
    setState(() => currentLanguage = lang);
    StorageService.saveLanguage(lang);
  }

  void toggleTheme() {
    final newMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setState(() => themeMode = newMode);
    StorageService.saveTheme(newMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Catholic Calendar 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: widget.startOnboarding
          ? const OnboardingScreen()
          : MainNavigation(
              key: const ValueKey('main_nav'),
              currentLanguage: currentLanguage,
              onLanguageChange: changeLanguage,
              onThemeToggle: toggleTheme,
              themeMode: themeMode,
            ),
    );
  }
}