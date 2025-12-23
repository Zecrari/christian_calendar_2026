import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class StorageService {
  static const String KEY_ONBOARDING = 'seen_onboarding';
  static const String KEY_REMINDERS = 'saved_reminders';
  static const String KEY_NOTIF_SOUND = 'notification_sound_v1';

  // Onboarding
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_ONBOARDING) ?? false;
  }

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_ONBOARDING, true);
  }

  // Reminders
  static Future<void> saveReminders(List<PrayerReminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(
      reminders.map((r) => r.toJson()).toList(),
    );
    await prefs.setString(KEY_REMINDERS, encoded);
  }

  static Future<List<PrayerReminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(KEY_REMINDERS);
    if (encoded == null) return [];
    final List<dynamic> decoded = json.decode(encoded);
    return decoded.map((json) => PrayerReminder.fromJson(json)).toList();
  }

  // Notification Sounds
  static Future<void> saveNotificationSound(String soundFileName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_NOTIF_SOUND, soundFileName);
  }

  static Future<String> loadNotificationSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_NOTIF_SOUND) ?? 'sound_1'; // Default to sound_1
  }
}
