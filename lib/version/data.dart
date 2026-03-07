import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// STORAGE SERVICE
// ============================================================================
class StorageService {
  static const String KEY_ONBOARDING = 'seen_onboarding';
  static const String KEY_REMINDERS = 'saved_reminders';

  // Check if user has seen onboarding
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_ONBOARDING) ?? false;
  }

  // Mark onboarding as seen
  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_ONBOARDING, true);
  }

  // Save Reminders List
  static Future<void> saveReminders(List<PrayerReminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(
      reminders.map((r) => r.toJson()).toList(),
    );
    await prefs.setString(KEY_REMINDERS, encoded);
  }

  // Load Reminders List
  static Future<List<PrayerReminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(KEY_REMINDERS);

    if (encoded == null) return []; // Return empty if nothing saved

    final List<dynamic> decoded = json.decode(encoded);
    return decoded.map((json) => PrayerReminder.fromJson(json)).toList();
  }
}

// Updated Model with JSON support and Frequency
class PrayerReminder {
  final String name;
  final TimeOfDay time;
  final bool enabled;
  final int iconCode; // Store icon as int code for JSON
  final int colorValue; // Store color as int value for JSON
  final String frequency; // 'Daily', 'Weekly', 'Monthly'

  PrayerReminder({
    required this.name,
    required this.time,
    required this.enabled,
    required this.iconCode,
    required this.colorValue,
    this.frequency = 'Daily',
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'hour': time.hour,
    'minute': time.minute,
    'enabled': enabled,
    'iconCode': iconCode,
    'colorValue': colorValue,
    'frequency': frequency,
  };

  // Create from JSON
  factory PrayerReminder.fromJson(Map<String, dynamic> json) {
    return PrayerReminder(
      name: json['name'],
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      enabled: json['enabled'],
      iconCode: json['iconCode'],
      colorValue: json['colorValue'],
      frequency: json['frequency'] ?? 'Daily',
    );
  }
}

// ============================================================================
// CONSTANTS & TRANSLATIONS
// ============================================================================

class BibleData {
  static Map<String, dynamic>? _bibleContent;
  static List<String> availableBooks = [];

  // தமிழ் புத்தகப் பெயர்கள் (வரிசைப்படி)
  static const List<String> tamilBookNames = [
    "ஆதியாகமம்",
    "யாத்திராகமம்",
    "லேவியராகமம்",
    "எண்ணாகமம்",
    "உபாகமம்",
    "யோசுவா",
    "நியாயாதிபதிகள்",
    "ரூத்",
    "1 சாமுவேல்",
    "2 சாமுவேல்",
    "1 இராஜாக்கள்",
    "2 இராஜாக்கள்",
    "1 நாளாகமம்",
    "2 நாளாகமம்",
    "எஸ்றா",
    "நெகேமியா",
    "எஸ்தர்",
    "யோபு",
    "சங்கீதம்",
    "நீதிமொழிகள்",
    "பிரசங்கி",
    "உன்னதப்பாட்டு",
    "ஏசாயா",
    "எரேமியா",
    "புலம்பல்",
    "எசேக்கியேல்",
    "தானியேல்",
    "ஓசியா",
    "யோவேல்",
    "ஆமோஸ்",
    "ஒபதியா",
    "யோனா",
    "மீகா",
    "நாகூம்",
    "ஆபகூக்",
    "செப்பனியா",
    "ஆகாய்",
    "சகரியா",
    "மல்கியா",
    "மத்தேயு",
    "மாற்கு",
    "லூக்கா",
    "யோவான்",
    "அப்போஸ்தலர்",
    "ரோமர்",
    "1 கொரிந்தியர்",
    "2 கொரிந்தியர்",
    "கலாத்தியர்",
    "எபேசியர்",
    "பிலிப்பியர்",
    "கொலோசெயர்",
    "1 தெசலோனிக்கேயர்",
    "2 தெசலோனிக்கேயர்",
    "1 தீமோத்தேயு",
    "2 தீமோத்தேயு",
    "தீத்து",
    "பிலேமோன்",
    "எபிரேயர்",
    "யாக்கோபு",
    "1 பேதுரு",
    "2 பேதுரு",
    "1 யோவான்",
    "2 யோவான்",
    "3 யோவான்",
    "யூதா",
    "வெளிப்படுத்தின விசேஷம்",
  ];

  // --- 1. LOAD DATA ---
  static Future<void> load(String langCode) async {
    _bibleContent = {};
    availableBooks = [];

    try {
      String filename =
          (langCode == 'ta') ? 'assets/bible_tamil.json.gz' : 'assets/bible.json.gz';
      print("Loading $filename...");
      final ByteData bytes = await rootBundle.load(filename);
      final List<int> compressed = bytes.buffer.asUint8List();
      final List<int> decompressed = GZipCodec().decode(compressed);
      final String response = utf8.decode(decompressed);
      final dynamic decodedData = json.decode(response);

      if (langCode == 'ta') {
        // --- TAMIL JSON PARSER (New Format) ---
        // Structure: {"Book": [ {"Chapter": [ {"Verse": [{"Verse": "text"}] } ] } ] }

        if (decodedData is Map && decodedData.containsKey('Book')) {
          List<dynamic> booksList = decodedData['Book'];

          for (int i = 0; i < booksList.length; i++) {
            // புத்தகத்தின் பெயரை வரிசைப்படி எடுக்கிறோம்
            String bookName =
                (i < tamilBookNames.length)
                    ? tamilBookNames[i]
                    : "Book ${i + 1}";
            availableBooks.add(bookName);

            var bookObj = booksList[i];
            var chaptersData = bookObj['Chapter'];

            // சில சமயம் Chapter ஒரு List ஆக இல்லாமல், ஒரே ஒரு Chapter இருந்தால் Object ஆக இருக்கலாம்
            List<dynamic> chaptersList =
                (chaptersData is List) ? chaptersData : [chaptersData];

            Map<String, dynamic> chaptersMap = {};

            for (int c = 0; c < chaptersList.length; c++) {
              String chapterNum = (c + 1).toString();

              var verseData = chaptersList[c]['Verse'];
              List<dynamic> versesList =
                  (verseData is List) ? verseData : [verseData];

              Map<String, String> versesMap = {};

              for (int v = 0; v < versesList.length; v++) {
                String verseNum = (v + 1).toString();
                // "Verse" என்ற key-ல் தான் வசனம் உள்ளது
                String text = versesList[v]['Verse'].toString();
                versesMap[verseNum] = text;
              }
              chaptersMap[chapterNum] = versesMap;
            }
            _bibleContent![bookName] = chaptersMap;
          }
          print(
            "Tamil Bible Loaded Successfully: ${availableBooks.length} books.",
          );
        } else {
          // பழைய List Format (GitHub style) க்கான Fallback
          print("Trying fallback list format...");
          // ... (பழைய குறியீடு இங்கே தேவைப்பட்டால் சேர்க்கலாம், ஆனால் புது JSON-க்கு இது தேவையில்லை)
        }
      } else {
        // --- ENGLISH ADAPTER (Standard Map) ---
        _bibleContent = Map<String, dynamic>.from(decodedData);
        availableBooks = _bibleContent!.keys.toList();
      }
    } catch (e) {
      print("CRITICAL ERROR loading Bible data: $e");
      availableBooks = ["Error"];
      _bibleContent = {
        "Error": {
          "1": {"1": "Error loading data. \nDetails: $e"},
        },
      };
    }
  }

  // --- 2. GET CHAPTER TEXT ---
  static String getChapterText(String book, int chapter) {
    if (_bibleContent == null || !_bibleContent!.containsKey(book))
      return "ஏற்றுகிறது...";

    final bookData = _bibleContent![book];
    final chapterKey = chapter.toString();

    if (bookData == null || !bookData.containsKey(chapterKey))
      return "அத்தியாயம் இல்லை.";

    final dynamic versesData = bookData[chapterKey];
    Map<String, dynamic> verses = {};

    if (versesData is Map) {
      verses = Map<String, dynamic>.from(versesData);
    }

    // வசனங்களை வரிசைப்படுத்துதல்
    final sortedVerseKeys =
        verses.keys.toList()
          ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    StringBuffer buffer = StringBuffer();
    for (var key in sortedVerseKeys) {
      buffer.write("$key. ${verses[key]}\n\n");
    }
    return buffer.toString().trim();
  }

  static int getChapterCount(String book) {
    if (_bibleContent == null || !_bibleContent!.containsKey(book)) return 50;
    return (_bibleContent![book] as Map).length;
  }

  // --- 3. SEARCH FUNCTION ---
  static List<Map<String, dynamic>> searchVerses(String query) {
    if (_bibleContent == null || query.isEmpty || query.length < 3) return [];

    List<Map<String, dynamic>> results = [];
    String lowerQuery = query.toLowerCase();

    for (var book in availableBooks) {
      var chapters = _bibleContent![book];
      if (chapters == null) continue;

      if (chapters is Map) {
        chapters.forEach((chapterNum, verses) {
          _searchInsideVerses(book, chapterNum, verses, lowerQuery, results);
        });
      }
    }
    return results;
  }

  static void _searchInsideVerses(
    String book,
    String chapterNum,
    dynamic verses,
    String query,
    List<Map<String, dynamic>> results,
  ) {
    if (results.length > 50) return;

    Map<String, dynamic> versesMap = {};
    if (verses is Map) {
      versesMap = Map<String, dynamic>.from(verses);
    }

    versesMap.forEach((verseNum, text) {
      if (text.toString().toLowerCase().contains(query)) {
        results.add({
          'book': book,
          'chapter': int.parse(chapterNum),
          'verse': verseNum,
          'text': text,
          'preview': _getPreview(text, query),
        });
      }
    });
  }

  static String _getPreview(String text, String query) {
    int idx = text.toLowerCase().indexOf(query);
    int start = (idx - 20) < 0 ? 0 : (idx - 20);
    int end =
        (idx + query.length + 50) > text.length
            ? text.length
            : (idx + query.length + 50);
    return "...${text.substring(start, end)}...";
  }
}

class AppConstants {
  static const String ENGLISH = 'en';
  static const String TAMIL = 'ta';

  static const List<LanguageOption> languages = [
    LanguageOption('English', 'en', '🇺🇸'),
    LanguageOption('தமிழ்', 'ta', '🇮🇳'),
  ];
}

class LanguageOption {
  final String name;
  final String code;
  final String flag;
  const LanguageOption(this.name, this.code, this.flag);
}

class AppTranslations {
  static Map<String, Map<String, String>> translations = {
    // Navigation
    'nav_home': {
      'en': 'Home',
      'es': 'Inicio',
      'fr': 'Accueil',
      'ta': 'முகப்பு',
    },
    'nav_calendar': {
      'en': 'Calendar',
      'es': 'Calendario',
      'fr': 'Calendrier',
      'ta': 'நாட்காட்டி',
    },
    'nav_reminders': {
      'en': 'Reminders',
      'es': 'Recordatorios',
      'fr': 'Rappels',
      'ta': 'நினைவூட்டல்கள்',
    },
    'nav_bible': {'en': 'Bible', 'es': 'Biblia', 'fr': 'Bible', 'ta': 'பைபிள்'},
    'nav_journal': {
      'en': 'Journal',
      'es': 'Diario',
      'fr': 'Journal',
      'ta': 'நாட்குறிப்பு',
    },
    'nav_saints': {
      'en': 'Saints',
      'es': 'Santos',
      'fr': 'Saints',
      'ta': 'புனிதர்கள்',
    },
    'nav_rosary': {
      'en': 'Rosary',
      'es': 'Rosario',
      'fr': 'Rosaire',
      'ta': 'ஜெபமாலை',
    },
    'nav_settings': {
      'en': 'Settings',
      'es': 'Ajustes',
      'fr': 'Paramètres',
      'ta': 'அமைப்புகள்',
    },

    // Dashboard
    'greeting': {
      'en': 'Blessings!',
      'es': '¡Bendiciones!',
      'fr': 'Bénédictions!',
      'ta': 'ஆசீர்வாதம்!',
    }, // Changed to more Christian greeting
    'verse_of_day': {
      'en': 'Verse of the Day',
      'es': 'Versículo del Día',
      'fr': 'Verset du Jour',
      'ta': 'இன்றைய வசனம்',
    },
    'today_events': {
      'en': 'Today\'s Events',
      'es': 'Eventos de Hoy',
      'fr': 'Événements du Jour',
      'ta': 'இன்றைய நிகழ்வுகள்',
    },
    'upcoming_events': {
      'en': 'Upcoming Events',
      'es': 'Próximos Eventos',
      'fr': 'Événements à Venir',
      'ta': 'வரவிருக்கும் நிகழ்வுகள்',
    },
    'no_events_today': {
      'en': 'No special events today',
      'es': 'No hay eventos especiales hoy',
      'fr': 'Pas d\'événements spéciaux aujourd\'hui',
      'ta': 'இன்று சிறப்பு நிகழ்வுகள் இல்லை',
    },
    'quick_actions': {
      'en': 'Quick Actions',
      'es': 'Acciones Rápidas',
      'fr': 'Actions Rapides',
      'ta': 'விரைவு செயல்கள்',
    },

    // Quick Actions
    'prayer_time': {
      'en': 'Prayer Time',
      'es': 'Tiempo de Oración',
      'fr': 'Temps de Prière',
      'ta': 'ஜெப நேரம்',
    },
    'daily_reading': {
      'en': 'Daily Reading',
      'es': 'Lectura Diaria',
      'fr': 'Lecture Quotidienne',
      'ta': 'தினசரி வாசிப்பு',
    },
    'add_prayer': {
      'en': 'Add Prayer',
      'es': 'Añadir Oración',
      'fr': 'Ajouter Prière',
      'ta': 'ஜெபம் சேர்',
    },
    'pray_rosary': {
      'en': 'Pray Rosary',
      'es': 'Rezar Rosario',
      'fr': 'Prier le Rosaire',
      'ta': 'ஜெபமாலை ஜெபிக்க',
    },

    // Calendar
    'liturgical_calendar': {
      'en': 'Liturgical Calendar',
      'es': 'Calendario Litúrgico',
      'fr': 'Calendrier Liturgique',
      'ta': 'வழிபாட்டு நாட்காட்டி',
    },
    'events_this_month': {
      'en': 'Events This Month',
      'es': 'Eventos de Este Mes',
      'fr': 'Événements ce Mois',
      'ta': 'இம்மாத நிகழ்வுகள்',
    },
    'no_events_month': {
      'en': 'No special events this month',
      'es': 'No hay eventos especiales este mes',
      'fr': 'Pas d\'événements spéciaux ce mois',
      'ta': 'இம்மாதம் சிறப்பு நிகழ்வுகள் இல்லை',
    },

    // Reminders
    'prayer_reminders': {
      'en': 'Prayer Reminders',
      'es': 'Recordatorios de Oración',
      'fr': 'Rappels de Prière',
      'ta': 'ஜெப நினைவூட்டல்கள்',
    },
    'morning_prayer': {
      'en': 'Morning Prayer',
      'es': 'Oración Matutina',
      'fr': 'Prière du Matin',
      'ta': 'காலை ஜெபம்',
    },
    'noon_prayer': {
      'en': 'Noon Prayer',
      'es': 'Oración del Mediodía',
      'fr': 'Prière de Midi',
      'ta': 'மதிய ஜெபம்',
    },
    'evening_prayer': {
      'en': 'Evening Prayer',
      'es': 'Oración Vespertina',
      'fr': 'Prière du Soir',
      'ta': 'மாலை ஜெபம்',
    },
    'night_prayer': {
      'en': 'Night Prayer',
      'es': 'Oración Nocturna',
      'fr': 'Prière de Nuit',
      'ta': 'இரவு ஜெபம்',
    },
    'add_new_reminder': {
      'en': 'Add New Reminder',
      'es': 'Añadir Nuevo Recordatorio',
      'fr': 'Ajouter un Nouveau Rappel',
      'ta': 'புதிய நினைவூட்டல் சேர்',
    },

    // Bible
    'bible_reader': {
      'en': 'Bible Reader',
      'es': 'Lector de Biblia',
      'fr': 'Lecteur de Bible',
      'ta': 'பைபிள் வாசிப்பு',
    },
    'book': {'en': 'Book', 'es': 'Libro', 'fr': 'Livre', 'ta': 'புத்தகம்'},
    'chapter': {
      'en': 'Chapter',
      'es': 'Capítulo',
      'fr': 'Chapitre',
      'ta': 'அதிகாரம்',
    },

    // Journal
    'prayer_journal': {
      'en': 'Prayer Journal',
      'es': 'Diario de Oración',
      'fr': 'Journal de Prière',
      'ta': 'ஜெப நாட்குறிப்பு',
    },

    // Saints
    'saints_devotionals': {
      'en': 'Saints & Devotionals',
      'es': 'Santos y Devocionales',
      'fr': 'Saints et Dévotions',
      'ta': 'புனிதர்கள் & பக்தி',
    },
    'saint_of_day': {
      'en': 'Saint of the Day',
      'es': 'Santo del Día',
      'fr': 'Saint du Jour',
      'ta': 'இன்றைய புனிதர்',
    },
    'devotional': {
      'en': 'Daily Devotional',
      'es': 'Devocional Diario',
      'fr': 'Dévotion Quotidienne',
      'ta': 'தினசரி பக்தி',
    },

    // Rosary
    'rosary_prayers': {
      'en': 'Rosary & Prayers',
      'es': 'Rosario y Oraciones',
      'fr': 'Rosaire et Prières',
      'ta': 'ஜெபமாலை & ஜெபங்கள்',
    },
    'mysteries': {
      'en': 'Mysteries',
      'es': 'Misterios',
      'fr': 'Mystères',
      'ta': 'இரகசியங்கள்',
    },
    'joyful': {
      'en': 'Joyful',
      'es': 'Gozosos',
      'fr': 'Joyeux',
      'ta': 'மகிழ்ச்சி',
    },
    'sorrowful': {
      'en': 'Sorrowful',
      'es': 'Dolorosos',
      'fr': 'Douloureux',
      'ta': 'துக்கம்',
    },
    'glorious': {
      'en': 'Glorious',
      'es': 'Gloriosos',
      'fr': 'Glorieux',
      'ta': 'மகிமை',
    },
    'luminous': {
      'en': 'Luminous',
      'es': 'Luminosos',
      'fr': 'Lumineux',
      'ta': 'ஒளி',
    },

    // Settings
    'appearance': {
      'en': 'Appearance',
      'es': 'Apariencia',
      'fr': 'Apparence',
      'ta': 'தோற்றம்',
    },
    'language': {
      'en': 'Language',
      'es': 'Idioma',
      'fr': 'Langue',
      'ta': 'மொழி',
    },
    'notifications': {
      'en': 'Notifications',
      'es': 'Notificaciones',
      'fr': 'Notifications',
      'ta': 'அறிவிப்புகள்',
    },
    'theme': {'en': 'Theme', 'es': 'Tema', 'fr': 'Thème', 'ta': 'தீம்'},
    'light': {'en': 'Light', 'es': 'Claro', 'fr': 'Clair', 'ta': 'வெளிச்சம்'},
    'dark': {'en': 'Dark', 'es': 'Oscuro', 'fr': 'Sombre', 'ta': 'இருட்டு'},
    'about': {
      'en': 'About',
      'es': 'Acerca de',
      'fr': 'À propos',
      'ta': 'பற்றி',
    },
  };

  static String get(String key, String lang) {
    return translations[key]?[lang] ?? translations[key]?['en'] ?? key;
  }
}

// ... inside lib/data.dart

// ============================================================================
// 2. HOLIDAY DATA (2026)
// ============================================================================

class ChristianEvents {
  static const goldColor = Color(0xFFFFA000);
  static const whiteColor = Color(
    0xFF90CAF9,
  ); // Light Blue/White representation
  static const purpleColor = Color(0xFF673AB7);
  static const redColor = Color(0xFFD32F2F);
  static const greenColor = Color(0xFF388E3C);

  static final Map<String, ChristianEvent> events = {
    // JANUARY
    '2026-01-01': ChristianEvent(
      'Solemnity of Mary',
      'Luke 2:19',
      goldColor,
      "But Mary kept all these things, and pondered them in her heart.",
    ),
    '2026-01-06': ChristianEvent(
      'Epiphany',
      'Matthew 2:11',
      goldColor,
      "And when they were come into the house, they saw the young child with Mary his mother, and fell down, and worshipped him.",
    ),
    '2026-01-11': ChristianEvent(
      'Baptism of Jesus',
      'Mark 1:11',
      whiteColor,
      "And there came a voice from heaven, saying, Thou art my beloved Son, in whom I am well pleased.",
    ),

    // FEBRUARY
    '2026-02-02': ChristianEvent(
      'Candlemas',
      'Luke 2:32',
      whiteColor,
      "A light to lighten the Gentiles, and the glory of thy people Israel.",
    ),
    '2026-02-14': ChristianEvent(
      'St. Valentine’s Day',
      '1 John 4:7',
      redColor,
      "Beloved, let us love one another: for love is of God; and every one that loveth is born of God.",
    ),
    '2026-02-18': ChristianEvent(
      'Ash Wednesday',
      'Joel 2:13',
      purpleColor,
      "Rend your heart, and not your garments, and turn unto the LORD your God.",
    ),

    // MARCH
    '2026-03-17': ChristianEvent(
      'St. Patrick’s Day',
      'Psalm 5:12',
      greenColor,
      "For thou, LORD, wilt bless the righteous; with favour wilt thou compass him as with a shield.",
    ),
    '2026-03-23': ChristianEvent(
      'St. Joseph’s Day',
      'Matthew 1:19',
      whiteColor,
      "Then Joseph her husband, being a just man... was minded to put her away privily.",
    ),
    '2026-03-29': ChristianEvent(
      'Palm Sunday',
      'John 12:13',
      redColor,
      "Took branches of palm trees, and went forth to meet him, and cried, Hosanna: Blessed is the King of Israel.",
    ),

    // APRIL
    '2026-04-02': ChristianEvent(
      'Maundy Thursday',
      'John 13:34',
      whiteColor,
      "A new commandment I give unto you, That ye love one another; as I have loved you.",
    ),
    '2026-04-03': ChristianEvent(
      'Good Friday',
      'John 19:30',
      redColor,
      "When Jesus therefore had received the vinegar, he said, It is finished: and he bowed his head, and gave up the ghost.",
    ),
    '2026-04-05': ChristianEvent(
      'Easter Sunday',
      'Luke 24:6',
      goldColor,
      "He is not here, but is risen: remember how he spake unto you when he was yet in Galilee.",
    ),
    '2026-04-06': ChristianEvent(
      'Easter Monday',
      'Luke 24:29',
      goldColor,
      "But they constrained him, saying, Abide with us: for it is toward evening, and the day is far spent.",
    ),
    '2026-04-23': ChristianEvent(
      'St. George\'s Day',
      'Ephesians 6:11',
      redColor,
      "Put on the whole armour of God, that ye may be able to stand against the wiles of the devil.",
    ),

    // MAY
    '2026-05-14': ChristianEvent(
      'Ascension of Jesus',
      'Acts 1:9',
      goldColor,
      "And when he had spoken these things, while they beheld, he was taken up; and a cloud received him out of their sight.",
    ),
    '2026-05-24': ChristianEvent(
      'Pentecost',
      'Acts 2:4',
      redColor,
      "And they were all filled with the Holy Ghost, and began to speak with other tongues, as the Spirit gave them utterance.",
    ),
    '2026-05-31': ChristianEvent(
      'Trinity Sunday',
      '1 John 5:7',
      whiteColor,
      "For there are three that bear record in heaven, the Father, the Word, and the Holy Ghost: and these three are one.",
    ),

    // JUNE
    '2026-06-04': ChristianEvent(
      'Corpus Christi',
      'John 6:51',
      whiteColor,
      "I am the living bread which came down from heaven: if any man eat of this bread, he shall live for ever.",
    ),
    '2026-06-29': ChristianEvent(
      'St. Peter and Paul',
      'Matthew 16:18',
      redColor,
      "And I say also unto thee, That thou art Peter, and upon this rock I will build my church.",
    ),

    // JULY
    '2026-07-15': ChristianEvent(
      'St. Vladimir',
      'Psalm 33:12',
      whiteColor,
      "Blessed is the nation whose God is the LORD; and the people whom he hath chosen for his own inheritance.",
    ),
    '2026-07-25': ChristianEvent(
      'St. James the Great',
      'Mark 1:17',
      redColor,
      "Come ye after me, and I will make you to become fishers of men.",
    ),

    // AUGUST
    '2026-08-01': ChristianEvent(
      'Lammas',
      'John 6:35',
      whiteColor,
      "And Jesus said unto them, I am the bread of life: he that cometh to me shall never hunger.",
    ),
    '2026-08-15': ChristianEvent(
      'Assumption of Mary',
      'Luke 1:46',
      whiteColor,
      "And Mary said, My soul doth magnify the Lord.",
    ),

    // SEPTEMBER
    '2026-09-14': ChristianEvent(
      'Holy Cross Day',
      'Galatians 6:14',
      redColor,
      "But God forbid that I should glory, save in the cross of our Lord Jesus Christ.",
    ),
    '2026-09-29': ChristianEvent(
      'Michael and All Angels',
      'Revelation 12:7',
      whiteColor,
      "And there was war in heaven: Michael and his angels fought against the dragon.",
    ),

    // OCTOBER
    '2026-10-31': ChristianEvent(
      'All Hallows’ Eve',
      'Psalm 23:4',
      purpleColor,
      "Yea, though I walk through the valley of the shadow of death, I will fear no evil: for thou art with me.",
    ),

    // NOVEMBER
    '2026-11-01': ChristianEvent(
      'All Saints’ Day',
      'Revelation 7:9',
      whiteColor,
      "After this I beheld, and, lo, a great multitude, which no man could number, of all nations.",
    ),
    '2026-11-02': ChristianEvent(
      'All Souls’ Day',
      'John 11:25',
      purpleColor,
      "Jesus said unto her, I am the resurrection, and the life: he that believeth in me, though he were dead, yet shall he live.",
    ),
    '2026-11-22': ChristianEvent(
      'Christ the King',
      'Revelation 19:16',
      goldColor,
      "And he hath on his vesture and on his thigh a name written, KING OF KINGS, AND LORD OF LORDS.",
    ),
    '2026-11-26': ChristianEvent(
      'Thanksgiving (USA)',
      'Psalm 100:4',
      whiteColor,
      "Enter into his gates with thanksgiving, and into his courts with praise.",
    ),
    '2026-11-29': ChristianEvent(
      'Advent – First Sunday',
      'Isaiah 9:2',
      purpleColor,
      "The people that walked in darkness have seen a great light.",
    ),
    '2026-11-30': ChristianEvent(
      'St. Andrew’s Day',
      'Matthew 4:19',
      redColor,
      "And he saith unto them, Follow me, and I will make you fishers of men.",
    ),

    // DECEMBER
    '2026-12-06': ChristianEvent(
      'St. Nicholas Day',
      'Matthew 19:14',
      whiteColor,
      "Suffer little children, and forbid them not, to come unto me: for of such is the kingdom of heaven.",
    ),
    '2026-12-24': ChristianEvent(
      'Christmas Eve',
      'Isaiah 7:14',
      goldColor,
      "Behold, a virgin shall conceive, and bear a son, and shall call his name Immanuel.",
    ),
    '2026-12-25': ChristianEvent(
      'Christmas',
      'Luke 2:11',
      goldColor,
      "For unto you is born this day in the city of David a Saviour, which is Christ the Lord.",
    ),
    '2026-12-28': ChristianEvent(
      'Holy Innocents’ Day',
      'Matthew 2:16',
      redColor,
      "Then Herod... sent forth, and slew all the children that were in Bethlehem.",
    ),
    '2026-12-31': ChristianEvent(
      'Watch Night',
      'Psalm 90:12',
      whiteColor,
      "So teach us to number our days, that we may apply our hearts unto wisdom.",
    ),
  };
}

class ChristianEvent {
  final String name;
  final String reference;
  final String verseText;
  final Color color;
  ChristianEvent(this.name, this.reference, this.color, this.verseText);
}

// ============================================================================
// DATA MODELS
// ============================================================================

class DailyVerses {
  static const List<Map<String, String>> verses = [
    {
      'text': 'For God so loved the world that he gave his one and only Son...',
      'reference': 'John 3:16',
    },
    {
      'text': 'I can do all things through Christ who strengthens me.',
      'reference': 'Philippians 4:13',
    },
    {
      'text': 'The Lord is my shepherd; I shall not want.',
      'reference': 'Psalm 23:1',
    },
    {'text': 'Be still, and know that I am God.', 'reference': 'Psalm 46:10'},
    {
      'text': 'Trust in the Lord with all your heart.',
      'reference': 'Proverbs 3:5',
    },
  ];
  static Map<String, String> getVerse(int day) => verses[day % verses.length];
}

class SaintsData {
  static const List<Map<String, String>> saints = [
    {
      'name': 'St. Mary, Mother of God',
      'feast': 'January 1',
      'bio': 'The Blessed Virgin Mary, mother of Jesus Christ.',
      'prayer': 'Hail Mary, full of grace.',
    },
    {
      'name': 'St. Joseph',
      'feast': 'March 19',
      'bio': 'Foster father of Jesus and patron of workers and families.',
      'prayer': 'St. Joseph, pray for us.',
    },
    {
      'name': 'St. Teresa of Calcutta',
      'feast': 'September 5',
      'bio': 'Missionary who served the poorest of the poor in Calcutta.',
      'prayer': 'Do small things with great love.',
    },
    {
      'name': 'St. Francis of Assisi',
      'feast': 'October 4',
      'bio': 'Founder of the Franciscan Order, known for his love of nature.',
      'prayer': 'Lord, make me an instrument of your peace.',
    },
  ];
  static Map<String, String> getSaintOfDay(int day) =>
      saints[day % saints.length];
}

class RosaryData {
  static const Map<String, List<String>> mysteries = {
    'Joyful': [
      'The Annunciation',
      'The Visitation',
      'The Nativity',
      'The Presentation',
      'Finding Jesus in the Temple',
    ],
    'Sorrowful': [
      'The Agony in the Garden',
      'The Scourging',
      'The Crowning with Thorns',
      'The Carrying of the Cross',
      'The Crucifixion',
    ],
    'Glorious': [
      'The Resurrection',
      'The Ascension',
      'The Descent of the Holy Spirit',
      'The Assumption',
      'The Coronation',
    ],
    'Luminous': [
      'The Baptism',
      'The Wedding at Cana',
      'The Proclamation',
      'The Transfiguration',
      'The Eucharist',
    ],
  };
  static const Map<String, String> prayers = {
    'Our Father': 'Our Father, who art in heaven, hallowed be thy name...',
    'Hail Mary': 'Hail Mary, full of grace, the Lord is with thee...',
    'Glory Be':
        'Glory be to the Father, and to the Son, and to the Holy Spirit...',
  };
}
