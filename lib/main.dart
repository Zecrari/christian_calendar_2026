import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:google_mobile_ads/google_mobile_ads.dart'; // <--- 1. NEW IMPORT
import 'data/storage_service.dart';
import 'screens/home/main_navigation.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'config/theme.dart';
import 'config/constants.dart';
import 'services/ad_helper.dart'; // <--- 2. NEW IMPORT (For Interstitial Logic)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // =========================================================
  // 3. INITIALIZE ADS (Must happen before runApp)
  // =========================================================
  await MobileAds.instance.initialize();

  // Optional: Preload the first Interstitial Ad so it is ready immediately
  // (Requires lib/services/ad_helper.dart to be created)
  AdHelper.loadInterstitialAd();
  // =========================================================

  // 4. Initialize Date Formatting
  await initializeDateFormatting();

  // 5. Initialize Timezones
  tz.initializeTimeZones();

  // 6. Initialize Storage & Check Onboarding
  final bool seenOnboarding = await StorageService.hasSeenOnboarding();

  // 7. Set Status Bar Style
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
  const ChristianCalendarApp({super.key, required this.startOnboarding});

  @override
  State<ChristianCalendarApp> createState() => _ChristianCalendarAppState();
}

class _ChristianCalendarAppState extends State<ChristianCalendarApp> {
  String currentLanguage = AppConstants.ENGLISH;
  ThemeMode themeMode = ThemeMode.light;

  void changeLanguage(String lang) {
    setState(() => currentLanguage = lang);
  }

  void toggleTheme() {
    setState(() {
      themeMode =
          themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Christian Calendar 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
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
