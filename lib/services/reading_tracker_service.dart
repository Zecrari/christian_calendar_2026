import 'package:intl/intl.dart';
import '../data/storage_service.dart';

class ReadingTrackerService {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  // Check and update streak when user reads
  static Future<Map<String, dynamic>> recordReading({
    required String book,
    required int chapter,
    int pagesRead = 5,
  }) async {
    final today = DateTime.now();
    final todayString = _dateFormat.format(today);
    
    int currentStreak = StorageService.getCurrentStreak();
    int longestStreak = StorageService.getLongestStreak();
    String? lastReadDate = StorageService.getLastReadDate();
    
    bool earnedStreak = false;
    bool earnedAchievement = false;
    String? achievementName;

    // Check if already read today
    if (lastReadDate == todayString) {
      // Already read today, just update chapter
    } else {
      // Check if continuing streak (read yesterday)
      final yesterday = today.subtract(const Duration(days: 1));
      final yesterdayString = _dateFormat.format(yesterday);
      
      if (lastReadDate == yesterdayString) {
        // Continue streak
        currentStreak++;
        earnedStreak = true;
      } else {
        // Streak broken or first time
        currentStreak = 1;
      }
      
      // Update longest streak
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
    }

    // Save progress
    final readChapters = StorageService.getReadChapters();
    readChapters.add('${book}_$chapter');
    
    final totalPages = StorageService.getTotalPagesRead() + pagesRead;

    await StorageService.saveReadingProgress(
      streak: currentStreak,
      longestStreak: longestStreak,
      lastReadDate: todayString,
      readChapters: readChapters,
      totalPages: totalPages,
      currentBook: book,
      currentChapter: chapter,
    );

    // Check achievements
    if (currentStreak == 7) {
      await StorageService.addAchievement('week_warrior');
      earnedAchievement = true;
      achievementName = 'Week Warrior';
    } else if (currentStreak == 30) {
      await StorageService.addAchievement('month_master');
      earnedAchievement = true;
      achievementName = 'Month Master';
    }

    // First chapter achievement
    if (readChapters.length == 1) {
      await StorageService.addAchievement('first_step');
      earnedAchievement = true;
      achievementName = 'First Step';
    }

    return {
      'streak': currentStreak,
      'longestStreak': longestStreak,
      'earnedStreak': earnedStreak,
      'earnedAchievement': earnedAchievement,
      'achievementName': achievementName,
      'totalChapters': readChapters.length,
    };
  }

  static bool hasReadToday() {
    final today = _dateFormat.format(DateTime.now());
    return StorageService.getLastReadDate() == today;
  }

  // FIXED: Handle division by zero and clamp values
  static double getBibleCompletionPercentage() {
    final readChapters = StorageService.getReadChapters().length;
    const totalChapters = 1189; // Total Bible chapters
    
    if (totalChapters == 0) return 0.0;
    if (readChapters == 0) return 0.0;
    
    double percentage = (readChapters / totalChapters) * 100;
    
    // Clamp to valid range and handle NaN/Infinity
    if (percentage.isNaN || percentage.isInfinite) {
      return 0.0;
    }
    
    return percentage.clamp(0.0, 100.0);
  }

  static int getChaptersReadInBook(String book) {
    final readChapters = StorageService.getReadChapters();
    return readChapters.where((c) => c.startsWith('${book}_')).length;
  }

  static List<bool> getLast7DaysActivity() {
    final lastReadDateStr = StorageService.getLastReadDate();
    if (lastReadDateStr == null) return List.filled(7, false);
    
    final currentStreak = StorageService.getCurrentStreak();
    DateTime? lastReadDate;
    try {
      lastReadDate = _dateFormat.parse(lastReadDateStr);
    } catch (_) {}

    final List<bool> activity = [];
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    
    for (int i = 6; i >= 0; i--) {
      bool isActive = false;
      if (lastReadDate != null && currentStreak > 0) {
        final targetDate = normalizedToday.subtract(Duration(days: i));
        // We know they read up until lastReadDate, for `currentStreak` consecutive days ending on lastReadDate.
        // Difference in days from targetDate to lastReadDate
        final diff = lastReadDate.difference(targetDate).inDays;
        
        // Target date is active if it's within the streak window BEFORE or ON lastReadDate
        // (diff >= 0 means targetDate is <= lastReadDate)
        // (diff < currentStreak means it is part of the current streak)
        if (diff >= 0 && diff < currentStreak) {
          isActive = true;
        }
      }
      activity.add(isActive);
    }
    
    return activity;
  }
}