// Auto-generated file
import 'package:flutter/material.dart';

class AppTheme {
  // Main Brand Color
  static const Color seedColor = Color(0xFF673AB7); // Deep Purple

  // LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      surface: const Color(0xFFFDFBF7), // Warm Parchment
      surfaceContainerHighest: const Color(0xFFF3E5F5),
    ),
    scaffoldBackgroundColor: const Color(0xFFFDFBF7),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFDFBF7),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade100),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFFDFBF7),
      indicatorColor: seedColor.withOpacity(0.15),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );

  // DARK THEME
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
