import 'package:flutter/material.dart';
import 'models.dart';

class ChristianEvents {
  // Liturgical Colors
  static const goldColor = Color(0xFFFFA000); // Solemnities / High Feasts
  static const whiteColor = Color(0xFF90CAF9); // Feasts / Saints (White/Blue)
  static const purpleColor = Color(0xFF673AB7); // Advent / Lent
  static const redColor = Color(0xFFD32F2F); // Martyrs / Holy Spirit / Passion
  static const greenColor = Color(0xFF388E3C); // Ordinary Time

  // ==============================================================================
  // PUBLIC HELPER: Get Event with Auto-Translation
  // ==============================================================================
  static ChristianEvent? getEvent(String dateKey, String lang) {
    if (!_events.containsKey(dateKey)) return null;

    final base = _events[dateKey]!;

    // If language is Tamil, try to find translation
    if (lang == 'ta') {
      return ChristianEvent(
        _taNames[base.name] ?? base.name, // Translate Name
        base.reference, // Reference stays standard (e.g. John 3:16)
        base.color,
        _taVerses[base.name] ?? base.verseText, // Translate Verse Text
      );
    }

    // Default to English base
    return base;
  }

  // ==============================================================================
  // 1. ENGLISH EVENTS (Base Data - Key is Date YYYY-MM-DD)
  // ==============================================================================
  static final Map<String, ChristianEvent> _events = {
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
      "And when they were come into the house, they saw the young child with Mary his mother.",
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
      "Beloved, let us love one another: for love is of God.",
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
    '2026-03-19': ChristianEvent(
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
      "When Jesus therefore had received the vinegar, he said, It is finished.",
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
      "But they constrained him, saying, Abide with us: for it is toward evening.",
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
      "And when he had spoken these things, while they beheld, he was taken up.",
    ),
    '2026-05-24': ChristianEvent(
      'Pentecost',
      'Acts 2:4',
      redColor,
      "And they were all filled with the Holy Ghost, and began to speak with other tongues.",
    ),
    '2026-05-31': ChristianEvent(
      'Trinity Sunday',
      '1 John 5:7',
      whiteColor,
      "For there are three that bear record in heaven, the Father, the Word, and the Holy Ghost.",
    ),

    // JUNE
    '2026-06-04': ChristianEvent(
      'Corpus Christi',
      'John 6:51',
      whiteColor,
      "I am the living bread which came down from heaven.",
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
      "Blessed is the nation whose God is the LORD.",
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
      "And Jesus said unto them, I am the bread of life.",
    ),
    '2026-08-06': ChristianEvent(
      'Transfiguration',
      'Matthew 17:2',
      whiteColor,
      "And was transfigured before them: and his face did shine as the sun.",
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
      "Yea, though I walk through the valley of the shadow of death, I will fear no evil.",
    ),

    // NOVEMBER
    '2026-11-01': ChristianEvent(
      'All Saints’ Day',
      'Revelation 7:9',
      whiteColor,
      "After this I beheld, and, lo, a great multitude, which no man could number.",
    ),
    '2026-11-02': ChristianEvent(
      'All Souls’ Day',
      'John 11:25',
      purpleColor,
      "Jesus said unto her, I am the resurrection, and the life.",
    ),
    '2026-11-22': ChristianEvent(
      'Christ the King',
      'Revelation 19:16',
      goldColor,
      "And he hath on his vesture and on his thigh a name written, KING OF KINGS, AND LORD OF LORDS.",
    ),
    '2026-11-26': ChristianEvent(
      'Thanksgiving',
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
      "Suffer little children, and forbid them not, to come unto me.",
    ),
    '2026-12-08': ChristianEvent(
      'Immaculate Conception',
      'Luke 1:28',
      whiteColor,
      "Hail, full of grace, the Lord is with thee: blessed art thou among women.",
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

  // ==============================================================================
  // 2. TAMIL TRANSLATIONS (Names)
  // ==============================================================================
  static final Map<String, String> _taNames = {
    'Solemnity of Mary': 'இறைவனின் தாய் மரியா பெருவிழா',
    'Epiphany': 'திருக்காட்சி பெருவிழா',
    'Baptism of Jesus': 'இயேசுவின் திருமுழுக்கு',
    'Candlemas': 'ஆண்டவரைக் கோவிலில் அர்ப்பணித்தல்',
    'St. Valentine’s Day': 'புனித வலன்டைன் நாள்',
    'Ash Wednesday': 'சாம்பல் புதன்',
    'St. Patrick’s Day': 'புனித பேட்ரிக் நாள்',
    'St. Joseph’s Day': 'புனித யோசேப்பு பெருவிழா',
    'Palm Sunday': 'குருத்தோலை ஞாயிறு',
    'Maundy Thursday': 'பெரிய வியாழன்',
    'Good Friday': 'புனித வெள்ளி (பெரிய வெள்ளி)',
    'Easter Sunday': 'உயிர்ப்பு ஞாயிறு (ஈஸ்டர்)',
    'Easter Monday': 'ஈஸ்டர் திங்கள்',
    'St. George\'s Day': 'புனித ஜார்ஜ் நாள்',
    'Ascension of Jesus': 'இயேசுவின் விண்ணேற்பு பெருவிழா',
    'Pentecost': 'பெந்தெகோஸ்தே பெருவிழா',
    'Trinity Sunday': 'மூவொரு இறைவன் பெருவிழா',
    'Corpus Christi': 'கிறிஸ்துவின் திருஉடல் திருஇரத்தப் பெருவிழா',
    'St. Peter and Paul': 'புனித பேதுரு மற்றும் பவுல்',
    'St. Vladimir': 'புனித விளாடிமிர்',
    'St. James the Great': 'புனித யாக்கோபு',
    'Lammas': 'லாமாஸ் பண்டிகை',
    'Transfiguration': 'இயேசுவின் உருமாற்றம்',
    'Assumption of Mary': 'கன்னி மரியாளின் விண்ணேற்பு',
    'Holy Cross Day': 'திருச்சிலுவை மகிமை',
    'Michael and All Angels': 'அதிதூதர் மிக்கேல் மற்றும் வானதூதர்கள்',
    'All Hallows’ Eve': 'புனிதர்களின் மாலை (Halloween)',
    'All Saints’ Day': 'அனைத்து புனிதர்கள் பெருவிழா',
    'All Souls’ Day': 'அனைத்து ஆன்மாக்கள் நாள்',
    'Christ the King': 'கிறிஸ்து அரசர் பெருவிழா',
    'Thanksgiving': 'நன்றி அறிதல் நாள்',
    'Advent – First Sunday': 'திருவருகைக்காலம் - முதல் ஞாயிறு',
    'St. Andrew’s Day': 'புனித அந்திரேயா',
    'St. Nicholas Day': 'புனித நிக்கோலஸ் நாள்',
    'Immaculate Conception': 'மரியாளின் அமல உற்பவம்',
    'Christmas Eve': 'கிறிஸ்து பிறப்பு திருவிழிப்பு',
    'Christmas': 'கிறிஸ்து பிறப்பு பெருவிழா',
    'Holy Innocents’ Day': 'மாசில்லா குழந்தைகள் நாள்',
    'Watch Night': 'புத்தாண்டு திருவிழிப்பு',
  };

  // ==============================================================================
  // 3. TAMIL TRANSLATIONS (Scripture/Verses)
  // ==============================================================================
  static final Map<String, String> _taVerses = {
    'Solemnity of Mary':
        'மரியாளோ அந்தச் சங்கதிகளையெல்லாம் தன் இருதயத்திலே வைத்துச் சிந்தனைபண்ணினாள்.',
    'Epiphany':
        'அவர்கள் அந்த வீட்டுக்குள் பிரவேசித்து, பிள்ளையையும் அதின் தாயாகிய மரியாளையும் கண்டு, சாஷ்டாங்கமாய் விழுந்து பணிந்துகொண்டார்கள்.',
    'Baptism of Jesus':
        'வானத்திலிருந்து ஒரு சத்தம் உண்டாகி: நீர் என்னுடைய நேசகுமாரன், உம்மில் பிரியமாயிருக்கிறேன் என்று உரைத்தது.',
    'Candlemas':
        'புறஜாதிகளுக்குப் பிரகாசிக்கிற ஒளியாகவும், உம்முடைய ஜனமாகிய இஸ்ரவேலுக்கு மகிமையாகவும்.',
    'St. Valentine’s Day':
        'பிரியமானவர்களே, ஒருவரிலொருவர் அன்பாயிருக்கக்கடவோம்; ஏனெனில் அன்பு தேவனால் உண்டாயிருக்கிறது.',
    'Ash Wednesday':
        'நீங்கள் உங்கள் வஸ்திரங்களையல்ல, உங்கள் இருதயங்களைக் கிழித்து, உங்கள் தேவனாகிய கர்த்தரிடத்தில் திரும்புங்கள்.',
    'St. Patrick’s Day':
        'கர்த்தாவே, நீர் நீதிமானை ஆசீர்வதித்து, காருண்ணியம் என்னும் கேடகத்தினால் அவனைச் சூழ்ந்துகொள்ளுவீர்.',
    'St. Joseph’s Day':
        'அவள் புருஷனாகிய யோசேப்பு நீதிமானாயிருந்து... அவளை இரகசியமாய் தள்ளிவிட யோசனையாயிருந்தான்.',
    'Palm Sunday':
        'குருத்தோலைகளைப் பிடித்துக்கொண்டு, அவருக்கு எதிர்கொண்டுபோகும்படி புறப்பட்டு: ஓசன்னா, இஸ்ரவேலின் ராஜாவாக வருகிறவர் ஸ்தோத்திரிக்கப்பட்டவர் என்று ஆர்ப்பரித்தார்கள்.',
    'Maundy Thursday':
        'நீங்கள் ஒருவரிலொருவர் அன்பாயிருங்கள்; நான் உங்களில் அன்பாயிருந்ததுபோல நீங்களும் ஒருவரிலொருவர் அன்பாயிருங்கள் என்கிற புதிதான கட்டளையை உங்களுக்குக் கொடுக்கிறேன்.',
    'Good Friday':
        'இயேசு காடியை வாங்கினபின்பு, முடிந்தது என்று சொல்லி, தலையைச் சாய்த்து, ஆவியை ஒப்புக்கொடுத்தார்.',
    'Easter Sunday':
        'அவர் இங்கே இல்லை, அவர் உயிர்த்தெழுந்தார்; அவர் கலிலேயாவிலிருந்தபோது உங்களுக்குச் சொன்னதை நினைவுகூருங்கள்.',
    'Easter Monday':
        'அவர்கள் அவரை நோக்கி: எங்களுடனே தங்கியிரும்; சாயங்காலமாகிறது, பொழுதும் போயிற்று என்று சொல்லி, அவரை வருந்திக் கேட்டுக்கொண்டார்கள்.',
    'St. George\'s Day':
        'பிசாசின் தந்திரங்களோடு எதிர்த்துநிற்கத் திராணியுள்ளவர்களாகும்படி, தேவனுடைய சர்வாயுதவர்க்கத்தையும் தரித்துக்கொள்ளுங்கள்.',
    'Ascension of Jesus':
        'இவைகளை அவர் சொன்னபின்பு, அவர்கள் பார்த்துக்கொண்டிருக்கையில், உயர எடுத்துக்கொள்ளப்பட்டார்; அவர்களுடைய கண்களுக்கு மறைவாக ஒரு மேகம் அவரை எடுத்துக்கொண்டது.',
    'Pentecost':
        'அவர்களெல்லாரும் பரிசுத்த ஆவியினாலே நிரப்பப்பட்டு, ஆவியானவர் தங்களுக்குத் தந்தருளின வரத்தின்படியே வெவ்வேறு பாஷைகளிலே பேசத்தொடங்கினார்கள்.',
    'Trinity Sunday':
        'பரலோகத்திலே சாட்சியிடுகிறவர்கள் பிதா, வார்த்தை, பரிசுத்த ஆவி என்பவர்களே, இம்மூவரும் ஒன்றாயிருக்கிறார்கள்.',
    'Corpus Christi':
        'நானே வானத்திலிருந்திறங்கின ஜீவ அப்பம்; இந்த அப்பத்தைப் புசிக்கிறவன் என்றென்றைக்கும் பிழைப்பான்.',
    'St. Peter and Paul':
        'நீ பேதுருவாய் இருக்கிறாய், இந்தக் கல்லின்மேல் என் சபையைக் கட்டுவேன்.',
    'St. Vladimir':
        'கர்த்தரைத் தங்களுக்குத் தேவனாகக்கொண்ட ஜாதியும், அவர் தங்களுக்குச் சுதந்தரமாகத் தெரிந்துகொண்ட ஜனமும் பாக்கியமுள்ளது.',
    'St. James the Great':
        'என் பின்னே வாருங்கள், உங்களை மனுஷரைப் பிடிக்கிறவர்களாக்குவேன் என்றார்.',
    'Lammas':
        'இயேசு அவர்களை நோக்கி: ஜீவ அப்பம் நானே, என்னிடத்தில் வருகிறவன் ஒருக்காலும் பசியடையான்.',
    'Transfiguration':
        'அவர்களுக்கு முன்பாக மறுரூபமானார்; அவர் முகம் சூரியனைப்போலப் பிரகாசித்தது.',
    'Assumption of Mary':
        'அப்பொழுது மரியாள்: என் ஆத்துமா கர்த்தரை மகிமைப்படுத்துகிறது என்றாள்.',
    'Holy Cross Day':
        'நம்முடைய கர்த்தராகிய இயேசுகிறிஸ்துவின் சிலுவையே அல்லாமல் வேறொன்றையுங்குறித்து நான் மேன்மைபாராட்டாதிருப்பேனாக.',
    'Michael and All Angels':
        'வானத்திலே யுத்தமுண்டாயிற்று; மிகாவேலும் அவனைச் சேர்ந்த தூதர்களும் வலுசர்ப்பத்தோடே யுத்தம்பண்ணினார்கள்.',
    'All Hallows’ Eve':
        'நான் மரண இருளின் பள்ளத்தாக்கிலே நடந்தாலும் பொல்லாப்புக்குப் பயப்படேன்; தேவரீர் என்னோடே கூட இருக்கிறீர்.',
    'All Saints’ Day':
        'இவைகளுக்குப்பின்பு, நான் பார்த்தபோது, இதோ, சகல ஜாதிகளிலும் கோத்திரங்களிலும் ஜனங்களிலும் பாஷைகளிலுரமிருந்து வந்த திரளான கூட்டமாகிய ஜனங்கள்.',
    'All Souls’ Day':
        'நானே உயிர்த்தெழுதலும் ஜீவனுமாயிருக்கிறேன், என்னை விசுவாசிக்கிறவன் மரித்தாலும் பிழைப்பான்.',
    'Christ the King':
        'ராஜாதிராஜா, கர்த்தாதி கர்த்தர் என்னும் நாமம் அவருடைய வஸ்திரத்தின்மேலும் அவருடைய தொடையின்மேலும் எழுதப்பட்டிருந்தது.',
    'Thanksgiving':
        'அவர் வாசல்களில் துதியோடும், அவர் பிராகாரங்களில் புகழ்ச்சியோடும் பிரவேசித்து, அவரைத் துதித்து, அவருடைய நாமத்தை ஸ்தோத்திரியுங்கள்.',
    'Advent – First Sunday':
        'இருளில் நடக்கிற ஜனங்கள் பெரிய வெளிச்சத்தைக் கண்டார்கள்.',
    'St. Andrew’s Day':
        'என் பின்னே வாருங்கள், உங்களை மனுஷரைப் பிடிக்கிறவர்களாக்குவேன் என்றார்.',
    'St. Nicholas Day':
        'சிறுபிள்ளைகள் என்னிடத்தில் வருகிறதற்கு இடங்கொடுங்கள்; அவர்களைத் தடைபண்ணாதிருங்கள்; பரலோகராஜ்யம் அப்படிப்பட்டவர்களுடையது.',
    'Immaculate Conception':
        'கிருபை பெற்றவளே வாழ்க, கர்த்தர் உன்னுடனே இருக்கிறார், ஸ்திரீகளுக்குள்ளே நீ ஆசீர்வதிக்கப்பட்டவள் என்றான்.',
    'Christmas Eve':
        'இதோ, ஒரு கன்னிகை கர்ப்பவதியாகி ஒரு குமாரனைப் பெறுவாள்; அவருக்கு இம்மானுவேல் என்று பேரிடுவார்கள்.',
    'Christmas':
        'இன்று கர்த்தராகிய கிறிஸ்து என்னும் இரட்சகர் உங்களுக்குத் தாவீதின் ஊரிலே பிறந்திருக்கிறார்.',
    'Holy Innocents’ Day':
        'ஏரோது... பெத்லகேமிலும் அதின் சகல எல்லைகளிலுமிருந்த இரண்டு வயதுக்குட்பட்ட எல்லா ஆண்பிள்ளைகளையும் கொலைசெய்தான்.',
    'Watch Night':
        'நாங்கள் ஞான இருதயமுள்ளவர்களாகும்படி, எங்கள் நாட்களை எண்ணும் அறிவை எங்களுக்குப் போதித்தருளும்.',
  };
}
