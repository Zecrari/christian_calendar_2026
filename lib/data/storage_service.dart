import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class StorageService {
  static const String KEY_ONBOARDING = 'seen_onboarding';
  static const String KEY_REMINDERS = 'saved_reminders';
  static const String KEY_NOTIF_SOUND = 'notification_sound_v1';
  static const String KEY_LANGUAGE = 'app_language';
  static const String KEY_THEME = 'app_theme_dark';
  
  // Reading Tracker Keys
  static const String KEY_READING_STREAK = 'reading_streak';
  static const String KEY_LONGEST_STREAK = 'longest_streak';
  static const String KEY_LAST_READ_DATE = 'last_read_date';
  static const String KEY_READ_CHAPTERS = 'read_chapters';
  static const String KEY_TOTAL_PAGES = 'total_pages_read';
  static const String KEY_ACHIEVEMENTS = 'achievements';
  static const String KEY_CURRENT_BOOK = 'current_book';
  static const String KEY_CURRENT_CHAPTER = 'current_chapter';

  static SharedPreferences? _prefs;
  
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static SharedPreferences get _instance {
    if (_prefs == null) throw Exception('StorageService not initialized');
    return _prefs!;
  }

  // --- SYNC METHODS ---
  static bool hasSeenOnboarding() => _instance.getBool(KEY_ONBOARDING) ?? false;
  static String loadLanguage() => _instance.getString(KEY_LANGUAGE) ?? 'en';
  static bool loadTheme() => _instance.getBool(KEY_THEME) ?? false;
  static String loadNotificationSound() => _instance.getString(KEY_NOTIF_SOUND) ?? 'sound_1';

  // --- READING TRACKER SYNC METHODS ---
  static int getCurrentStreak() => _instance.getInt(KEY_READING_STREAK) ?? 0;
  static int getLongestStreak() => _instance.getInt(KEY_LONGEST_STREAK) ?? 0;
  static String? getLastReadDate() => _instance.getString(KEY_LAST_READ_DATE);
  static int getTotalPagesRead() => _instance.getInt(KEY_TOTAL_PAGES) ?? 0;
  static String getCurrentBook() => _instance.getString(KEY_CURRENT_BOOK) ?? 'Genesis';
  static int getCurrentChapter() => _instance.getInt(KEY_CURRENT_CHAPTER) ?? 1;
  
  static Set<String> getReadChapters() {
    final List<String>? chapters = _instance.getStringList(KEY_READ_CHAPTERS);
    return chapters?.toSet() ?? {};
  }

  static List<String> getAchievements() {
    return _instance.getStringList(KEY_ACHIEVEMENTS) ?? [];
  }

  // --- ASYNC SAVE METHODS ---
  static Future<void> completeOnboarding() async => 
      await _instance.setBool(KEY_ONBOARDING, true);
  
  static Future<void> saveLanguage(String lang) async => 
      await _instance.setString(KEY_LANGUAGE, lang);
  
  static Future<void> saveTheme(bool isDark) async => 
      await _instance.setBool(KEY_THEME, isDark);

  static Future<void> saveNotificationSound(String sound) async => 
      await _instance.setString(KEY_NOTIF_SOUND, sound);

  // --- READING TRACKER SAVE METHODS ---
  static Future<void> saveReadingProgress({
    required int streak,
    required int longestStreak,
    required String lastReadDate,
    required Set<String> readChapters,
    required int totalPages,
    required String currentBook,
    required int currentChapter,
  }) async {
    await _instance.setInt(KEY_READING_STREAK, streak);
    await _instance.setInt(KEY_LONGEST_STREAK, longestStreak);
    await _instance.setString(KEY_LAST_READ_DATE, lastReadDate);
    await _instance.setStringList(KEY_READ_CHAPTERS, readChapters.toList());
    await _instance.setInt(KEY_TOTAL_PAGES, totalPages);
    await _instance.setString(KEY_CURRENT_BOOK, currentBook);
    await _instance.setInt(KEY_CURRENT_CHAPTER, currentChapter);
  }

  static Future<void> addAchievement(String achievement) async {
    final achievements = getAchievements();
    if (!achievements.contains(achievement)) {
      achievements.add(achievement);
      await _instance.setStringList(KEY_ACHIEVEMENTS, achievements);
    }
  }

  static Future<void> markChapterRead(String book, int chapter) async {
    final readChapters = getReadChapters();
    readChapters.add('${book}_$chapter');
    await _instance.setStringList(KEY_READ_CHAPTERS, readChapters.toList());
  }

  // Reminders
  static Future<void> saveReminders(List<PrayerReminder> reminders) async {
    final String encoded = json.encode(reminders.map((r) => r.toJson()).toList());
    await _instance.setString(KEY_REMINDERS, encoded);
  }

  static List<PrayerReminder> loadReminders() {
    final String? encoded = _instance.getString(KEY_REMINDERS);
    if (encoded == null) return [];
    final List<dynamic> decoded = json.decode(encoded);
    return decoded.map((json) => PrayerReminder.fromJson(json)).toList();
  }
}