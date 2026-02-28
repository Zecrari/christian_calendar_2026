// Saints' Feast Day data — used for Personal Feast Day feature
// Maps saint name keywords (lowercase) to feast date (month, day) and display info

class SaintFeastDay {
  final String name;
  final int month;
  final int day;
  final String greeting;
  final String greetingTa;
  final String greetingHi;

  const SaintFeastDay({
    required this.name,
    required this.month,
    required this.day,
    required this.greeting,
    required this.greetingTa,
    required this.greetingHi,
  });
}

class SaintFeastData {
  // Map of lowercase name → feast data
  static final List<SaintFeastDay> saintFeasts = [
    SaintFeastDay(name: 'mary', month: 1, day: 1, greeting: 'Happy Feast of Mary, Mother of God! 🌹', greetingTa: 'கடவுளின் தாய் மரியா பெருவிழா நாள் வாழ்த்துக்கள்! 🌹', greetingHi: 'ईश्वर की माता मरियम पर्व की शुभकामनाएं! 🌹'),
    SaintFeastDay(name: 'joseph', month: 3, day: 19, greeting: 'Happy Feast of St. Joseph! ✝️', greetingTa: 'புனித யோசேப்பு திருவிழா நாள் வாழ்த்துக்கள்! ✝️', greetingHi: 'संत जोसेफ के पर्व की शुभकामनाएं! ✝️'),
    SaintFeastDay(name: 'patrick', month: 3, day: 17, greeting: 'Happy Feast of St. Patrick! 🍀', greetingTa: 'புனித பேட்ரிக் திருவிழா நாள் வாழ்த்துக்கள்! 🍀', greetingHi: 'संत पेट्रिक के पर्व की शुभकामनाएं! 🍀'),
    SaintFeastDay(name: 'george', month: 4, day: 23, greeting: 'Happy Feast of St. George! ⚔️', greetingTa: 'புனித ஜார்ஜ் திருவிழா நாள் வாழ்த்துக்கள்! ⚔️', greetingHi: 'संत जॉर्ज के पर्व की शुभकामनाएं! ⚔️'),
    SaintFeastDay(name: 'peter', month: 6, day: 29, greeting: 'Happy Feast of St. Peter! 🗝️', greetingTa: 'புனித பேதுரு திருவிழா நாள் வாழ்த்துக்கள்! 🗝️', greetingHi: 'संत पेत्रुस के पर्व की शुभकामनाएं! 🗝️'),
    SaintFeastDay(name: 'paul', month: 6, day: 29, greeting: 'Happy Feast of St. Paul! ✉️', greetingTa: 'புனித பவுல் திருவிழா நாள் வாழ்த்துக்கள்! ✉️', greetingHi: 'संत पौलुस के पर्व की शुभकामनाएं! ✉️'),
    SaintFeastDay(name: 'james', month: 7, day: 25, greeting: 'Happy Feast of St. James! ✝️', greetingTa: 'புனித யாக்கோபு திருவிழா நாள் வாழ்த்துக்கள்! ✝️', greetingHi: 'संत याकूब के पर्व की शुभकामनाएं! ✝️'),
    SaintFeastDay(name: 'anne', month: 7, day: 26, greeting: 'Happy Feast of St. Anne! 🌺', greetingTa: 'புனித அன்னை திருவிழா நாள் வாழ்த்துக்கள்! 🌺', greetingHi: 'संत अन्ना के पर्व की शुभकामनाएं! 🌺'),
    SaintFeastDay(name: 'joachim', month: 7, day: 26, greeting: 'Happy Feast of St. Joachim! ✝️', greetingTa: 'புனித ஜோவாக்கிம் திருவிழா நாள் வாழ்த்துக்கள்! ✝️', greetingHi: 'संत योआखिम के पर्व की शुभकामनाएं! ✝️'),
    SaintFeastDay(name: 'dominic', month: 8, day: 8, greeting: 'Happy Feast of St. Dominic! 📿', greetingTa: 'புனித டொமினிக் திருவிழா நாள் வாழ்த்துக்கள்! 📿', greetingHi: 'संत डोमिनिक के पर्व की शुभकामनाएं! 📿'),
    SaintFeastDay(name: 'lawrence', month: 8, day: 10, greeting: 'Happy Feast of St. Lawrence! 🔥', greetingTa: 'புனித லாரன்ஸ் திருவிழா நாள் வாழ்த்துக்கள்! 🔥', greetingHi: 'संत लॉरेंस के पर्व की शुभकामनाएं! 🔥'),
    SaintFeastDay(name: 'augustine', month: 8, day: 28, greeting: 'Happy Feast of St. Augustine! 📖', greetingTa: 'புனித அகஸ்டின் திருவிழா நாள் வாழ்த்துக்கள்! 📖', greetingHi: 'संत ऑगस्टीन के पर्व की शुभकामनाएं! 📖'),
    SaintFeastDay(name: 'michael', month: 9, day: 29, greeting: 'Happy Feast of St. Michael the Archangel! ⚡', greetingTa: 'அதிதூதர் மிக்கேல் திருவிழா நாள் வாழ்த்துக்கள்! ⚡', greetingHi: 'महादूत सेंट माइकल के पर्व की शुभकामनाएं! ⚡'),
    SaintFeastDay(name: 'gabriel', month: 9, day: 29, greeting: 'Happy Feast of St. Gabriel! 🕊️', greetingTa: 'தூதர் கப்ரியேல் திருவிழா நாள் வாழ்த்துக்கள்! 🕊️', greetingHi: 'गब्रियेल महादूत के पर्व की शुभकामनाएं! 🕊️'),
    SaintFeastDay(name: 'raphael', month: 9, day: 29, greeting: 'Happy Feast of St. Raphael! 💊', greetingTa: 'தூதர் ரபாயேல் திருவிழா நாள் வாழ்த்துக்கள்! 💊', greetingHi: 'संत रफाएल के पर्व की शुभकामनाएं! 💊'),
    SaintFeastDay(name: 'francis', month: 10, day: 4, greeting: 'Happy Feast of St. Francis of Assisi! 🐦', greetingTa: 'புனித பிரான்சிஸ் திருவிழா நாள் வாழ்த்துக்கள்! 🐦', greetingHi: 'संत फ्रांसिस के पर्व की शुभकामनाएं! 🐦'),
    SaintFeastDay(name: 'luke', month: 10, day: 18, greeting: 'Happy Feast of St. Luke! 📜', greetingTa: 'புனித லூக்கா திருவிழா நாள் வாழ்த்துக்கள்! 📜', greetingHi: 'संत लूका के पर्व की शुभकामनाएं! 📜'),
    SaintFeastDay(name: 'simon', month: 10, day: 28, greeting: 'Happy Feast of St. Simon! ✝️', greetingTa: 'புனித சீமோன் திருவிழா நாள் வாழ்த்துக்கள்! ✝️', greetingHi: 'संत सिमोन के पर्व की शुभकामनाएं! ✝️'),
    SaintFeastDay(name: 'jude', month: 10, day: 28, greeting: 'Happy Feast of St. Jude! 🙏', greetingTa: 'புனித யூதா திருவிழா நாள் வாழ்த்துக்கள்! 🙏', greetingHi: 'संत यूदा के पर्व की शुभकामनाएं! 🙏'),
    SaintFeastDay(name: 'andrew', month: 11, day: 30, greeting: 'Happy Feast of St. Andrew! 🎯', greetingTa: 'புனித அந்திரேயா திருவிழா நாள் வாழ்த்துக்கள்! 🎯', greetingHi: 'संत आन्द्रेयास के पर्व की शुभकामनाएं! 🎯'),
    SaintFeastDay(name: 'nicholas', month: 12, day: 6, greeting: 'Happy Feast of St. Nicholas! 🎁', greetingTa: 'புனித நிக்கோலஸ் திருவிழா நாள் வாழ்த்துக்கள்! 🎁', greetingHi: 'संत निकोलस के पर्व की शुभகामनाएं! 🎁'),
    SaintFeastDay(name: 'thomas', month: 7, day: 3, greeting: 'Happy Feast of St. Thomas! ✝️', greetingTa: 'புனித தோமா திருவிழா நாள் வாழ்த்துக்கள்! ✝️', greetingHi: 'संत थॉमस के पर्व की शुभकामनाएं! ✝️'),
    SaintFeastDay(name: 'matthew', month: 9, day: 21, greeting: 'Happy Feast of St. Matthew! 📖', greetingTa: 'புனித மத்தேயு திருவிழா நாள் வாழ்த்துக்கள்! 📖', greetingHi: 'संत मत्ती के पर्व की शुभकामनाएं! 📖'),
    SaintFeastDay(name: 'mark', month: 4, day: 25, greeting: 'Happy Feast of St. Mark! ✍️', greetingTa: 'புனித மாற்கு திருவிழா நாள் வாழ்த்துக்கள்! ✍️', greetingHi: 'संत मरकुस के पर्व की शुभकामनाएं! ✍️'),
    SaintFeastDay(name: 'john', month: 12, day: 27, greeting: 'Happy Feast of St. John! ❤️', greetingTa: 'புனித யோவான் திருவிழா நாள் வாழ்த்துக்கள்! ❤️', greetingHi: 'संत यूहन्ना के पर्व की शुभकामनाएं! ❤️'),
    SaintFeastDay(name: 'stephen', month: 12, day: 26, greeting: 'Happy Feast of St. Stephen! 👑', greetingTa: 'புனித ஸ்தேவான் திருவிழா நாள் வாழ்த்துக்கள்! 👑', greetingHi: 'संत स्तिफनुस के पर्व की शुभकामनाएं! 👑'),
    SaintFeastDay(name: 'teresa', month: 10, day: 1, greeting: 'Happy Feast of St. Thérèse of Lisieux! 🌹', greetingTa: 'புனித திரேசா திருவிழா நாள் வாழ்த்துக்கள்! 🌹', greetingHi: 'संत तेरेसा के पर्व की शुभकामनाएं! 🌹'),
    SaintFeastDay(name: 'therese', month: 10, day: 1, greeting: 'Happy Feast of St. Thérèse! 🌹', greetingTa: 'புனித திரேசா திருவிழா நாள் வாழ்த்துக்கள்! 🌹', greetingHi: 'संत तेरेसा के पर्व की शुभकामनाएं! 🌹'),
    SaintFeastDay(name: 'anthony', month: 6, day: 13, greeting: 'Happy Feast of St. Anthony of Padua! 🔑', greetingTa: 'புனித அந்தோணியார் திருவிழா நாள் வாழ்த்துக்கள்! 🔑', greetingHi: 'संत अंतोनी के पर्व की शुभकामनाएं! 🔑'),
    SaintFeastDay(name: 'ignatius', month: 7, day: 31, greeting: 'Happy Feast of St. Ignatius of Loyola! ✝️', greetingTa: 'புனித இஞ்ஞாசியார் திருவிழா நாள் வாழ்த்துக்கள்! ✝️', greetingHi: 'संत इग्नेशियस के पर्व की शुभकामनाएं! ✝️'),
    SaintFeastDay(name: 'pius', month: 9, day: 23, greeting: 'Happy Feast of St. Padre Pio! ✝️', greetingTa: 'புனித பட்ரே பியோ திருவிழா நாள் வாழ்த்துக்கள்! ✝️', greetingHi: 'संत पाद्रे पियो के पर्व की शुभकामनाएं! ✝️'),
    SaintFeastDay(name: 'faustina', month: 10, day: 5, greeting: 'Happy Feast of St. Faustina! 🌊', greetingTa: 'புனித ஃபஸ்டினா திருவிழா நாள் வாழ்த்துக்கள்! 🌊', greetingHi: 'संत फॉस्टिना के पर्व की शुभकामनाएं! 🌊'),
    SaintFeastDay(name: 'benedict', month: 7, day: 11, greeting: 'Happy Feast of St. Benedict! 🏔️', greetingTa: 'புனித பெனடிக்ட் திருவிழா நாள் வாழ்த்துக்கள்! 🏔️', greetingHi: 'संत बेनेडिक्ट के पर्व की शुभकामनाएं! 🏔️'),
    SaintFeastDay(name: 'sebastian', month: 1, day: 20, greeting: 'Happy Feast of St. Sebastian! 🏹', greetingTa: 'புனித செபஸ்தியான் திருவிழா நாள் வாழ்த்துக்கள்! 🏹', greetingHi: 'संत सेबास्तियन के पर्व की शुभकामनाएं! 🏹'),
    SaintFeastDay(name: 'cecilia', month: 11, day: 22, greeting: 'Happy Feast of St. Cecilia! 🎵', greetingTa: 'புனித செசிலியா திருவிழா நாள் வாழ்த்துக்கள்! 🎵', greetingHi: 'संत सेसिलिया के पर्व की शुभकामनाएं! 🎵'),
    SaintFeastDay(name: 'monica', month: 8, day: 27, greeting: 'Happy Feast of St. Monica! 🙏', greetingTa: 'புனித மோனிகா திருவிழா நாள் வாழ்த்துக்கள்! 🙏', greetingHi: 'संत मोनिका के पर्व की शुभकामनाएं! 🙏'),
    SaintFeastDay(name: 'elizabeth', month: 11, day: 17, greeting: 'Happy Feast of St. Elizabeth! 👑', greetingTa: 'புனித எலிசபெத் திருவிழா நாள் வாழ்த்துக்கள்! 👑', greetingHi: 'संत एलिजाबेथ के पर्व की शुभकामनाएं! 👑'),
    SaintFeastDay(name: 'rose', month: 8, day: 23, greeting: 'Happy Feast of St. Rose of Lima! 🌹', greetingTa: 'புனித ரோஸ் திருவிழா நாள் வாழ்த்துக்கள்! 🌹', greetingHi: 'संत रोज के पर्व की शुभकामनाएं! 🌹'),
    SaintFeastDay(name: 'lucia', month: 12, day: 13, greeting: 'Happy Feast of St. Lucy! 🕯️', greetingTa: 'புனித லூசியா திருவிழா நாள் வாழ்த்துக்கள்! 🕯️', greetingHi: 'संत लूसिया के पर्व की शुभकामनाएं! 🕯️'),
    SaintFeastDay(name: 'lucy', month: 12, day: 13, greeting: 'Happy Feast of St. Lucy! 🕯️', greetingTa: 'புனித லூசியா திருவிழா நாள் வாழ்த்துக்கள்! 🕯️', greetingHi: 'संत लूसिया के पर्व की शुभकामनाएं! 🕯️'),
    SaintFeastDay(name: 'anna', month: 7, day: 26, greeting: 'Happy Feast of St. Anne! 🌺', greetingTa: 'புனித அன்னை திருவிழா நாள் வாழ்த்துக்கள்! 🌺', greetingHi: 'संत अन्ना के पर्व की शुभकामनाएं! 🌺'),
    SaintFeastDay(name: 'agatha', month: 2, day: 5, greeting: 'Happy Feast of St. Agatha! 🕊️', greetingTa: 'புனித அகதா திருவிழா நாள் வாழ்த்துக்கள்! 🕊️', greetingHi: 'संत अगाथा के पर्व की शुभकामनाएं! 🕊️'),
    SaintFeastDay(name: 'blaise', month: 2, day: 3, greeting: 'Happy Feast of St. Blaise! 🕯️', greetingTa: 'புனித பிளேஸ் திருவிழா நாள் வாழ்த்துக்கள்! 🕯️', greetingHi: 'संत ब्लेज के पर्व की शुभकामनाएं! 🕯️'),
    SaintFeastDay(name: 'valentine', month: 2, day: 14, greeting: 'Happy Feast of St. Valentine! ❤️', greetingTa: 'புனித வலன்டைன் திருவிழா நாள் வாழ்த்துக்கள்! ❤️', greetingHi: 'संत वैलेंटाइन के पर्व की शुभकामनाएं! ❤️'),
    SaintFeastDay(name: 'pius', month: 9, day: 23, greeting: 'Happy Feast of St. Pio! ✝️', greetingTa: 'புனித பியோ திருவிழா நாள் வாழ்த்துக்கள்! ✝️', greetingHi: 'संत पियो के पर्व की शुभकामनाएं! ✝️'),
  ];

  /// Looks up a saint by name (fuzzy match) and returns feast info or null
  static SaintFeastDay? findSaintByName(String input) {
    final lower = input.toLowerCase().trim();
    if (lower.isEmpty) return null;
    // Try exact match first
    for (final s in saintFeasts) {
      if (s.name == lower) return s;
    }
    // Try contains match
    for (final s in saintFeasts) {
      if (lower.contains(s.name) || s.name.contains(lower)) return s;
    }
    return null;
  }

  /// Checks if today is the feast day of the given saint
  static bool isFeastDayToday(SaintFeastDay saint) {
    final today = DateTime.now();
    return today.month == saint.month && today.day == saint.day;
  }

  /// Returns upcoming feast day info (null if not within 7 days)
  static Map<String, dynamic>? getUpcomingFeast(SaintFeastDay saint) {
    final today = DateTime.now();
    final feastThisYear = DateTime(today.year, saint.month, saint.day);
    final diff = feastThisYear.difference(DateTime(today.year, today.month, today.day)).inDays;
    
    if (diff >= 0 && diff <= 30) {
      return {
        'days': diff,
        'date': feastThisYear,
      };
    }
    // Try next year
    final feastNextYear = DateTime(today.year + 1, saint.month, saint.day);
    final diffNext = feastNextYear.difference(DateTime(today.year, today.month, today.day)).inDays;
    return {'days': diffNext, 'date': feastNextYear};
  }
}
