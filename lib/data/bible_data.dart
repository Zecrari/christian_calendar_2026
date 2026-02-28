// Auto-generated file
import 'dart:convert';
import 'package:flutter/services.dart';

class BibleData {
  static Map<String, dynamic>? _bibleContent;
  static List<String> availableBooks = [];

  static Future<void> load(String langCode) async {
    _bibleContent = {};
    availableBooks = [];

    try {
      String filename;
      if (langCode == 'ta') {
        filename = 'assets/bible_tamil.json';
      } else if (langCode == 'hi') {
        filename = 'assets/bible_hindi.json';
      } else if (langCode == 'ml') {
        filename = 'assets/bible_malayalam.json';
      } else {
        filename = 'assets/bible.json';
      }
      final String response = await rootBundle.loadString(filename);
      final dynamic decodedData = json.decode(response);

      if (langCode == 'ta' || langCode == 'hi' || langCode == 'ml') {
        // Tamil / Hindi / Malayalam Adapter
        final List<String> bookNames;
        if (langCode == 'hi') {
          bookNames = hindiBookNames;
        } else if (langCode == 'ml') {
          bookNames = malayalamBookNames;
        } else {
          bookNames = tamilBookNames;
        }
        if (decodedData is Map && decodedData.containsKey('Book')) {
          List<dynamic> booksList = decodedData['Book'];
          for (int i = 0; i < booksList.length; i++) {
            String bookName =
                (i < bookNames.length)
                    ? bookNames[i]
                    : "Book ${i + 1}";
            availableBooks.add(bookName);
            var bookObj = booksList[i];
            var chaptersData = bookObj['Chapter'];
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
                String text = versesList[v]['Verse'].toString();
                versesMap[verseNum] = text;
              }
              chaptersMap[chapterNum] = versesMap;
            }
            _bibleContent![bookName] = chaptersMap;
          }
        }
      } else {
        // English Adapter
        _bibleContent = Map<String, dynamic>.from(decodedData);
        availableBooks = _bibleContent!.keys.toList();
      }
    } catch (e) {
      print("Error loading Bible JSON: $e");
      availableBooks = ["Genesis"];
      _bibleContent = {
        "Genesis": {
          "1": {"1": "Error loading bible data."},
        },
      };
    }
  }

  static String getChapterText(String book, int chapter) {
    if (_bibleContent == null || !_bibleContent!.containsKey(book))
      return "Loading...";
    final bookData = _bibleContent![book];
    final chapterKey = chapter.toString();
    if (bookData == null || !bookData.containsKey(chapterKey))
      return "End of Book.";

    final dynamic versesData = bookData[chapterKey];
    Map<String, dynamic> verses = {};
    if (versesData is Map)
      verses = Map<String, dynamic>.from(versesData);
    else if (versesData is List) {
      for (int i = 0; i < versesData.length; i++)
        verses[(i + 1).toString()] = versesData[i];
    }

    final sortedKeys =
        verses.keys.toList()
          ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    StringBuffer buffer = StringBuffer();
    for (var key in sortedKeys) buffer.write("$key. ${verses[key]}\n\n");
    return buffer.toString().trim();
  }

  static int getChapterCount(String book) {
    if (_bibleContent == null || !_bibleContent!.containsKey(book)) return 50;
    return (_bibleContent![book] as Map).length;
  }

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
    if (verses is Map) versesMap = Map<String, dynamic>.from(verses);

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

  static const List<String> hindiBookNames = [
    "उत्पत्ति",
    "निर्गमन",
    "लैव्यव्यवस्था",
    "गिनती",
    "व्यवस्थाविवरण",
    "यहोशू",
    "न्यायियों",
    "रूत",
    "1 शमूएल",
    "2 शमूएल",
    "1 राजाओं",
    "2 राजाओं",
    "1 इतिहास",
    "2 इतिहास",
    "एज्रा",
    "नहेमायाह",
    "एस्तेर",
    "अय्यूब",
    "भजन संहिता",
    "नीतिवचन",
    "सभोपदेशक",
    "श्रेष्ठगीत",
    "यशायाह",
    "यिर्मयाह",
    "विलापगीत",
    "यहेजकेल",
    "दानिय्येल",
    "होशे",
    "योएल",
    "आमोस",
    "ओबद्याह",
    "योना",
    "मीका",
    "नाहूम",
    "हबक्कूक",
    "सपन्याह",
    "हाग्गै",
    "जकर्याह",
    "मलाकी",
    "मत्ती",
    "मरकुस",
    "लूका",
    "यूहन्ना",
    "प्रेरितों के काम",
    "रोमियों",
    "1 कुरिन्थियों",
    "2 कुरिन्थियों",
    "गलातियों",
    "इफिसियों",
    "फिलिप्पियों",
    "कुलुस्सियों",
    "1 थिस्सलुनीकियों",
    "2 थिस्सलुनीकियों",
    "1 तीमुथियुस",
    "2 तीमुथियुस",
    "तीतुस",
    "फिलेमोन",
    "इब्रानियों",
    "याकूब",
    "1 पतरस",
    "2 पतरस",
    "1 यूहन्ना",
    "2 यूहन्ना",
    "3 यूहन्ना",
    "यहूदा",
    "प्रकाशितवाक्य",
  ];

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

  static const List<String> malayalamBookNames = [
    "ഉൽപ്പത്തി",
    "പുറപ്പാട്",
    "ലേവ്യ",
    "സംഖ്യ",
    "ആവർത്തനം",
    "യോശുവ",
    "ന്യായാധിപന്മാർ",
    "രൂത്ത്",
    "1 ശമൂവേൽ",
    "2 ശമൂവേൽ",
    "1 രാജാക്കൾ",
    "2 രാജാക്കൾ",
    "1 ദിനവൃത്താന്തം",
    "2 ദിനവൃത്താന്തം",
    "എസ്രാ",
    "നെഹെമ്യാ",
    "എസ്ഥേർ",
    "ഇയ്യോബ്",
    "സങ്കീർത്തനം",
    "സദൃശ്യവാക്യങ്ങൾ",
    "സഭാപ്രസംഗി",
    "ഉത്തമഗീതം",
    "യെശയ്യ",
    "യിരെമ്യ",
    "വിലാപങ്ങൾ",
    "യെഹെസ്കേൽ",
    "ദാനീയേൽ",
    "ഹോശേയ",
    "യോവേൽ",
    "ആമോസ്",
    "ഓബദ്യ",
    "യോനാ",
    "മീഖ",
    "നഹൂം",
    "ഹബക്കൂക്",
    "സെഫന്യ",
    "ഹഗ്ഗൈ",
    "സെഖര്യ",
    "മലാഖി",
    "മത്തായി",
    "മർക്കൊസ്",
    "ലൂക്കൊസ്",
    "യോഹന്നാൻ",
    "അപ്പോ. പ്രവൃത്തികൾ",
    "റോമർ",
    "1 കൊരിന്ത്യർ",
    "2 കൊരിന്ത്യർ",
    "ഗലാത്യർ",
    "എഫേസ്യർ",
    "ഫിലിപ്പ്യർ",
    "കൊലൊസ്സ്യർ",
    "1 തെസ്സലൊനീക്യർ",
    "2 തെസ്സലൊനീക്യർ",
    "1 തിമൊഥെയൊസ്",
    "2 തിമൊഥെയൊസ്",
    "തീത്തൊസ്",
    "ഫിലേമോൻ",
    "എബ്രായർ",
    "യാക്കോബ്",
    "1 പത്രൊസ്",
    "2 പത്രൊസ്",
    "1 യോഹന്നാൻ",
    "2 യോഹന്നാൻ",
    "3 യോഹന്നാൻ",
    "യൂദാ",
    "വെളിപ്പാട്",
  ];
}

class DailyVerses {
  // English Verses
  static const List<Map<String, String>> _versesEn = [
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

  // Tamil Verses
  static const List<Map<String, String>> _versesTa = [
    {
      'text':
          'தேவன் தம்முடைய ஒரேபேறான குமாரனை விசுவாசிக்கிறவன் எவனோ அவன் கெட்டுப்போகாமல் நித்தியஜீவனை அடையும்படிக்கு, அவரைத் தந்தருளி, இவ்வளவாய் உலகத்தில் அன்புூர்ந்தார்.',
      'reference': 'யோவான் 3:16',
    },
    {
      'text':
          'என்னைப் பெலப்படுத்துகிற கிறிஸ்துவினாலே எல்லாவற்றையுஞ்செய்ய எனக்குப் பெலனுண்டு.',
      'reference': 'பிலிப்பியர் 4:13',
    },
    {
      'text': 'கர்த்தர் என் மேய்ப்பராயிருக்கிறார்; நான் தாழ்ச்சியடையேன்.',
      'reference': 'சங்கீதம் 23:1',
    },
    {
      'text': 'நீங்கள் அமர்ந்திருந்து, நானே தேவனென்று அறிந்துகொள்ளுங்கள்.',
      'reference': 'சங்கீதம் 46:10',
    },
    {
      'text':
          'உன் சுயபுத்தியின்மேல் சாயாமல், உன் முழு இருதயத்தோடும் கர்த்தரில் நம்பிக்கையாயிரு.',
      'reference': 'நீதிமொழிகள் 3:5',
    },
  ];

  // Hindi Verses
  static const List<Map<String, String>> _versesHi = [
    {
      'text':
          'क्योंकि परमेश्वर ने जगत से ऐसा प्रेम रखा कि उसने अपना एकलौता पुत्र दे दिया, ताकि जो कोई उस पर विश्वास करे, वह नाश न हो, परन्तु अनन्त जीवन पाए।',
      'reference': 'यूहन्ना 3:16',
    },
    {
      'text': 'मैं उस मसीह के द्वारा जो मुझे सामर्थ देता है, सब कुछ कर सकता हूं।',
      'reference': 'फिलिप्पियों 4:13',
    },
    {
      'text': 'यहोवा मेरा चरवाहा है; मुझे कुछ घटी न होगी।',
      'reference': 'भजन संहिता 23:1',
    },
    {
      'text': 'स्थिर हो जाओ, और जानो कि मैं ही परमेश्वर हूं।',
      'reference': 'भजन संहिता 46:10',
    },
    {
      'text':
          'अपने सम्पूर्ण हृदय से यहोवा पर भरोसा रखना, और अपनी समझ का सहारा न लेना।',
      'reference': 'नीतिवचन 3:5',
    },
  ];

  // Malayalam Verses
  static const List<Map<String, String>> _versesMl = [
    {
      'text': 'ദൈവം ലോകത്തെ അതിശയമായി സ്നേഹിച്ചതിനാൽ, തന്റെ ഏകജാതനായ പുത്രനെ നൽകി; അവനിൽ വിശ്വസിക്കുന്ന ഏവനും നശിക്കാതെ നിത്യജീവൻ ലഭിക്കേണ്ടതിന്നു തന്നേ.',
      'reference': 'യോഹ 3:16',
    },
    {
      'text': 'എനിക്കു ശക്തി നൽകുന്ന ക്രിസ്തുവിൽകൂടി ഞാൻ സകലവും ചെയ്‍വാൻ കഴിയും.',
      'reference': 'ഫിലി 4:13',
    },
    {
      'text': 'കർത്താവ് എന്റെ ഇടയൻ; എനിക്കു മുട്ടുണ്ടാകയില്ല.',
      'reference': 'സങ്കീ 23:1',
    },
    {
      'text': 'അടങ്ങിയിരിപ്പിൻ; ഞാൻ ദൈവം എന്നു അറിഞ്ഞുകൊൾവിൻ.',
      'reference': 'സങ്കീ 46:10',
    },
    {
      'text': 'നിന്റെ പൂർണ്ണഹൃദയത്തോടും കർത്താവിൽ ആശ്രയിക്ക; സ്വന്ത ബുദ്ധിയിൽ ഊന്നരുത്.',
      'reference': 'സദൃ 3:5',
    },
  ];

  // UPDATED METHOD: Now accepts (int day, String lang)
  static Map<String, String> getVerse(int day, String lang) {
    if (lang == 'ta') return _versesTa[day % _versesTa.length];
    if (lang == 'hi') return _versesHi[day % _versesHi.length];
    if (lang == 'ml') return _versesMl[day % _versesMl.length];
    return _versesEn[day % _versesEn.length];
  }
}
