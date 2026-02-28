// Liturgical Calendar Calculator
// Computes moveable feasts based on Easter (Computus Algorithm)

class LiturgicalCalculator {
  /// Computes Easter Sunday for a given year using the Anonymous Gregorian Algorithm.
  static DateTime easterSunday(int year) {
    final int a = year % 19;
    final int b = year ~/ 100;
    final int c = year % 100;
    final int d = b ~/ 4;
    final int e = b % 4;
    final int f = (b + 8) ~/ 25;
    final int g = (b - f + 1) ~/ 3;
    final int h = (19 * a + b - d - g + 15) % 30;
    final int i = c ~/ 4;
    final int k = c % 4;
    final int l = (32 + 2 * e + 2 * i - h - k) % 7;
    final int m = (a + 11 * h + 22 * l) ~/ 451;
    final int month = (h + l - 7 * m + 114) ~/ 31;
    final int day = ((h + l - 7 * m + 114) % 31) + 1;
    return DateTime(year, month, day);
  }

  /// Ash Wednesday = Easter - 46 days
  static DateTime ashWednesday(int year) =>
      easterSunday(year).subtract(const Duration(days: 46));

  /// Palm Sunday = Easter - 7 days
  static DateTime palmSunday(int year) =>
      easterSunday(year).subtract(const Duration(days: 7));

  /// Good Friday = Easter - 2 days
  static DateTime goodFriday(int year) =>
      easterSunday(year).subtract(const Duration(days: 2));

  /// Maundy Thursday = Easter - 3 days
  static DateTime maundyThursday(int year) =>
      easterSunday(year).subtract(const Duration(days: 3));

  /// Ascension = Easter + 39 days
  static DateTime ascension(int year) =>
      easterSunday(year).add(const Duration(days: 39));

  /// Pentecost = Easter + 49 days
  static DateTime pentecost(int year) =>
      easterSunday(year).add(const Duration(days: 49));

  /// Trinity Sunday = Pentecost + 7 days
  static DateTime trinitySunday(int year) =>
      pentecost(year).add(const Duration(days: 7));

  /// Corpus Christi = Trinity Sunday + 4 days (Thursday after Trinity)
  static DateTime corpusChristi(int year) =>
      trinitySunday(year).add(const Duration(days: 4));

  /// First Sunday of Advent = Sunday on or before Nov 30
  static DateTime firstSundayOfAdvent(int year) {
    final nov30 = DateTime(year, 11, 30);
    // weekday: 1=Mon..7=Sun. Find the Sunday on or before Nov 30
    final int daysToSubtract = nov30.weekday % 7; // Sun=0
    return nov30.subtract(Duration(days: daysToSubtract));
  }

  /// Returns all moveable feasts for a given year as a Map<DateTime, String>
  static Map<DateTime, String> getMoveableFeasts(int year) {
    return {
      ashWednesday(year): 'Ash Wednesday',
      palmSunday(year): 'Palm Sunday',
      maundyThursday(year): 'Maundy Thursday',
      goodFriday(year): 'Good Friday',
      easterSunday(year): 'Easter Sunday',
      easterSunday(year).add(const Duration(days: 1)): 'Easter Monday',
      ascension(year): 'Ascension of Jesus',
      pentecost(year): 'Pentecost',
      trinitySunday(year): 'Trinity Sunday',
      corpusChristi(year): 'Corpus Christi',
      firstSundayOfAdvent(year): 'Advent – First Sunday',
    };
  }

  /// Check if a given date is a fasting day (Friday OR Ash Wednesday OR Good Friday)
  static bool isFastingDay(DateTime date) {
    if (date.weekday == DateTime.friday) return true;
    final ash = ashWednesday(date.year);
    final gf = goodFriday(date.year);
    return (date.year == ash.year &&
            date.month == ash.month &&
            date.day == ash.day) ||
        (date.year == gf.year &&
            date.month == gf.month &&
            date.day == gf.day);
  }

  /// Returns a human-readable label for the fasting day
  static String getFastingLabel(DateTime date, String lang) {
    final ash = ashWednesday(date.year);
    final gf = goodFriday(date.year);

    bool isAsh = date.year == ash.year &&
        date.month == ash.month &&
        date.day == ash.day;
    bool isGf =
        date.year == gf.year && date.month == gf.month && date.day == gf.day;

    if (isAsh) {
      if (lang == 'ta') return '🕯 சாம்பல் புதன் – உபவாசம்';
      if (lang == 'hi') return '🕯 भस्म बुधवार – उपवास';
      return '🕯 Ash Wednesday – Day of Fast & Abstinence';
    }
    if (isGf) {
      if (lang == 'ta') return '✝ பெரிய வெள்ளி – கடுமையான உபவாசம்';
      if (lang == 'hi') return '✝ गुड फ्राइडे – कठोर उपवास';
      return '✝ Good Friday – Strict Fast & Abstinence';
    }
    // Regular Friday
    if (lang == 'ta') return '🐟 வெள்ளி – மாமிசம் தவிர்க்கவும்';
    if (lang == 'hi') return '🐟 शुक्रवार – मांस से परहेज करें';
    return '🐟 Friday – Day of Abstinence from Meat';
  }

  /// Returns number of days until Easter from today
  static int daysUntilEaster(int year) {
    final today = DateTime.now();
    final easter = easterSunday(year);
    return easter.difference(DateTime(today.year, today.month, today.day)).inDays;
  }

  /// Returns number of days until Lent start (Ash Wednesday) from today
  static int daysUntilLent(int year) {
    final today = DateTime.now();
    final ash = ashWednesday(year);
    return ash.difference(DateTime(today.year, today.month, today.day)).inDays;
  }
}
