import 'models.dart';

class RosaryDatabase {
  // ==============================================================================
  // 1. MYSTERIES (ENGLISH)
  // ==============================================================================
  static final Map<String, List<MysteryModel>> _mysteriesEn = {
    'Joyful': [
      const MysteryModel(
        title: "The Annunciation",
        fruit: "Humility",
        scripture: "Luke 1:38",
        description:
            "The Angel Gabriel announces to Mary that she will be the mother of God.",
      ),
      const MysteryModel(
        title: "The Visitation",
        fruit: "Love of Neighbor",
        scripture: "Luke 1:41",
        description:
            "Mary visits her cousin Elizabeth, who is also with child.",
      ),
      const MysteryModel(
        title: "The Nativity",
        fruit: "Poverty",
        scripture: "Luke 2:7",
        description: "Jesus is born in a stable in Bethlehem.",
      ),
      const MysteryModel(
        title: "The Presentation",
        fruit: "Obedience",
        scripture: "Luke 2:22",
        description: "Mary and Joseph present Jesus in the Temple.",
      ),
      const MysteryModel(
        title: "Finding in the Temple",
        fruit: "Joy",
        scripture: "Luke 2:46",
        description: "Jesus is found teaching the elders in the Temple.",
      ),
    ],
    'Sorrowful': [
      const MysteryModel(
        title: "The Agony in the Garden",
        fruit: "Sorrow for Sin",
        scripture: "Luke 22:44",
        description: "Jesus prays in Gethsemane on the night before He dies.",
      ),
      const MysteryModel(
        title: "The Scourging at the Pillar",
        fruit: "Purity",
        scripture: "John 19:1",
        description: "Pilate orders Jesus to be whipped.",
      ),
      const MysteryModel(
        title: "Crowning with Thorns",
        fruit: "Courage",
        scripture: "Matt 27:29",
        description: "Soldiers mock Jesus as King with a crown of thorns.",
      ),
      const MysteryModel(
        title: "Carrying of the Cross",
        fruit: "Patience",
        scripture: "John 19:17",
        description: "Jesus carries the heavy cross to Calvary.",
      ),
      const MysteryModel(
        title: "The Crucifixion",
        fruit: "Salvation",
        scripture: "Luke 23:46",
        description: "Jesus dies on the cross for our sins.",
      ),
    ],
    'Glorious': [
      const MysteryModel(
        title: "The Resurrection",
        fruit: "Faith",
        scripture: "Mark 16:6",
        description: "Jesus rises from the dead, conquering death.",
      ),
      const MysteryModel(
        title: "The Ascension",
        fruit: "Hope",
        scripture: "Acts 1:9",
        description: "Jesus ascends into Heaven to the Father.",
      ),
      const MysteryModel(
        title: "Descent of the Holy Spirit",
        fruit: "Wisdom",
        scripture: "Acts 2:4",
        description: "The Holy Spirit comes down upon the Apostles.",
      ),
      const MysteryModel(
        title: "The Assumption",
        fruit: "Devotion",
        scripture: "Psalm 132:8",
        description: "Mary is taken body and soul into Heaven.",
      ),
      const MysteryModel(
        title: "The Coronation",
        fruit: "Eternal Happiness",
        scripture: "Rev 12:1",
        description: "Mary is crowned Queen of Heaven and Earth.",
      ),
    ],
    'Luminous': [
      const MysteryModel(
        title: "The Baptism",
        fruit: "Openness",
        scripture: "Matt 3:17",
        description: "God proclaims Jesus as His beloved Son.",
      ),
      const MysteryModel(
        title: "Wedding at Cana",
        fruit: "To Jesus through Mary",
        scripture: "John 2:5",
        description: "Jesus turns water into wine at Mary's request.",
      ),
      const MysteryModel(
        title: "Proclamation",
        fruit: "Repentance",
        scripture: "Mark 1:15",
        description: "Jesus preaches the Gospel and calls for conversion.",
      ),
      const MysteryModel(
        title: "Transfiguration",
        fruit: "Holiness",
        scripture: "Matt 17:2",
        description: "Jesus is revealed in glory to Peter, James, and John.",
      ),
      const MysteryModel(
        title: "Institution of Eucharist",
        fruit: "Adoration",
        scripture: "Luke 22:19",
        description: "Jesus offers His Body and Blood as food for our souls.",
      ),
    ],
  };

  // ==============================================================================
  // 2. MYSTERIES (TAMIL)
  // ==============================================================================
  static final Map<String, List<MysteryModel>> _mysteriesTa = {
    'Joyful': [
      const MysteryModel(
        title: "கபிரியேல் தூதர் மரியாளுக்குத் தூது உரைத்தது",
        fruit: "தாழ்ச்சி",
        scripture: "லூக்கா 1:38",
        description:
            "கபிரியேல் தூதர் மரியாளிடம் இயேசுவின் பிறப்பை அறிவிக்கிறார்.",
      ),
      const MysteryModel(
        title: "மரியாள் எலிசபெத்தைச் சந்தித்தது",
        fruit: "பிறரன்பு",
        scripture: "லூக்கா 1:41",
        description: "மரியாள் தன் உறவினராகிய எலிசபெத்தை சந்திக்கிறார்.",
      ),
      const MysteryModel(
        title: "இயேசுவின் பிறப்பு",
        fruit: "எளிமை",
        scripture: "லூக்கா 2:7",
        description: "இயேசு பெத்லகேமில் ஒரு மாட்டுத் தொழுவத்தில் பிறக்கிறார்.",
      ),
      const MysteryModel(
        title: "இயேசுவைக் கோவிலில் காணிக்கையாகக் கொடுத்தது",
        fruit: "கீழ்ப்படிதல்",
        scripture: "லூக்கா 2:22",
        description:
            "மரியாளும் யோசேப்பும் இயேசுவை எருசலேம் கோவிலில் அர்ப்பணிக்கிறார்கள்.",
      ),
      const MysteryModel(
        title: "காணாமற்போன இயேசுவைக் கண்டடைந்தது",
        fruit: "கடவுளைத் தேடுதல்",
        scripture: "லூக்கா 2:46",
        description:
            "மூன்று நாட்களுக்குப் பிறகு இயேசுவை கோவிலில் காண்கிறார்கள்.",
      ),
    ],
    'Sorrowful': [
      const MysteryModel(
        title: "இயேசு பூங்காவனத்தில் இரத்த வேர்வை சிந்தியது",
        fruit: "பாவத்திற்காக வருந்துதல்",
        scripture: "லூக்கா 22:44",
        description: "இயேசு கெத்சமணி தோட்டதில் ஜெபிக்கிறார்.",
      ),
      const MysteryModel(
        title: "இயேசு கற்றூணில் கட்டுண்டு வாரினால் அடிக்கப்பட்டது",
        fruit: "உட ஒடுக்கம்",
        scripture: "யோவான் 19:1",
        description: "பிலாத்து இயேசுவை வாரினால் அடிக்கக் கட்டளையிடுகிறான்.",
      ),
      const MysteryModel(
        title: "இயேசுவுக்கு முள்முடி சூட்டப்பட்டது",
        fruit: "பொறுமை",
        scripture: "மத்தேயு 27:29",
        description:
            "வீரர்கள் இயேசுவுக்கு முள்முடி சூட்டி ஏளனம் செய்கிறார்கள்.",
      ),
      const MysteryModel(
        title: "இயேசு சிலுவை சுமந்து சென்றது",
        fruit: "துன்பத்தை ஏற்பது",
        scripture: "யோவான் 19:17",
        description: "இயேசு கல்வாரி மலைக்கு சிலுவை சுமந்து செல்கிறார்.",
      ),
      const MysteryModel(
        title: "இயேசு சிலுவையில் அறையப்பட்டு மரித்தது",
        fruit: "மீட்பு",
        scripture: "லூக்கா 23:46",
        description: "இயேசு சிலுவையில் மரித்து நம் பாவங்களைப் போக்குகிறார்.",
      ),
    ],
    'Glorious': [
      const MysteryModel(
        title: "இயேசு உயிர்த்தெழுந்தது",
        fruit: "விசுவாசம்",
        scripture: "மாற்கு 16:6",
        description: "மூன்றாம் நாள் இயேசு உயிர்த்தெழுந்தார்.",
      ),
      const MysteryModel(
        title: "இயேசு விண்ணேற்றமடைந்தது",
        fruit: "நம்பிக்கை",
        scripture: "அப் 1:9",
        description: "இயேசு விண்ணகத்திற்குத் தந்தையிடம் செல்கிறார்.",
      ),
      const MysteryModel(
        title: "தூய ஆவியார் வருகை",
        fruit: "இறை அன்பு",
        scripture: "அப் 2:4",
        description: "தூய ஆவியார் சீடர்கள் மீது இறங்கி வருகிறார்.",
      ),
      const MysteryModel(
        title: "மரியாள் விண்ணேற்றமடைந்தது",
        fruit: "நல்மரணம்",
        scripture: "சங்கீதம் 132:8",
        description:
            "மரியாள் உடலோடும் ஆன்மாவோடும் விண்ணகத்திற்கு எடுத்துக் கொள்ளப்படுகிறார்.",
      ),
      const MysteryModel(
        title: "மரியாள் விண்ணக அரசியாக முடிசூட்டப்பட்டது",
        fruit: "விண்ணக மகிழ்ச்சி",
        scripture: "தி.வெ 12:1",
        description: "மரியாள் விண்ணக, மண்ணக அரசியாக முடிசூட்டப்படுகிறார்.",
      ),
    ],
    'Luminous': [
      const MysteryModel(
        title: "இயேசுவின் திருமுழுக்கு",
        fruit: "அருள்",
        scripture: "மத்தேயு 3:17",
        description: "யோர்தான் நதியில் இயேசு திருமுழுக்கு பெறுகிறார்.",
      ),
      const MysteryModel(
        title: "கானாவூர் திருமணம்",
        fruit: "நம்பிக்கை",
        scripture: "யோவான் 2:5",
        description: "இயேசு தண்ணீரை திராட்சை ரசமாக மாற்றுகிறார்.",
      ),
      const MysteryModel(
        title: "இறையரசு அறிவிப்பு",
        fruit: "மனமாற்றம்",
        scripture: "மாற்கு 1:15",
        description: "இயேசு நற்செய்தியை அறிவித்து மனமாற அழைக்கிறார்.",
      ),
      const MysteryModel(
        title: "இயேசுவின் உருமாற்றம்",
        fruit: "புனிதம்",
        scripture: "மத்தேயு 17:2",
        description: "இயேசு தாபோர் மலையில் உருமாறுகிறார்.",
      ),
      const MysteryModel(
        title: "நற்கருணை ஏற்படுத்துதல்",
        fruit: "பக்தி",
        scripture: "லூக்கா 22:19",
        description:
            "இயேசு நற்கருணையைத் தன் உடலாகவும் இரத்தமாகவும் கொடுக்கிறார்.",
      ),
    ],
  };

  // --- PUBLIC GETTER ---
  static List<MysteryModel> getMysteries(String type, String lang) {
    if (lang == 'ta') return _mysteriesTa[type] ?? [];
    if (lang == 'hi') return _mysteriesHi[type] ?? [];
    if (lang == 'ml') return _mysteriesMl[type] ?? [];
    return _mysteriesEn[type] ?? [];
  }

  // ==============================================================================
  // 3. MYSTERIES (HINDI)
  // ==============================================================================
  static final Map<String, List<MysteryModel>> _mysteriesHi = {
    'Joyful': [
      const MysteryModel(
        title: "घोषणा",
        fruit: "विनम्रता",
        scripture: "लूका 1:38",
        description:
            "देवदूत गब्रियल मरियम को बताते हैं कि वह ईश्वर की माँ बनेंगी।",
      ),
      const MysteryModel(
        title: "भेंट",
        fruit: "पड़ोसी प्रेम",
        scripture: "लूका 1:41",
        description: "मरियम अपनी चचेरी बहन एलिसाबेत से मिलने जाती हैं।",
      ),
      const MysteryModel(
        title: "येसु का जन्म",
        fruit: "निर्धनता",
        scripture: "लूका 2:7",
        description: "येसु का जन्म बेथलहम में एक गौशाला में होता है।",
      ),
      const MysteryModel(
        title: "मंदिर में अर्पण",
        fruit: "आज्ञाकारिता",
        scripture: "लूका 2:22",
        description: "मरियम और यूसुफ येसु को मंदिर में अर्पित करते हैं।",
      ),
      const MysteryModel(
        title: "मंदिर में येसु की खोज",
        fruit: "आनंद",
        scripture: "लूका 2:46",
        description: "येसु मंदिर में बुजुर्गों को शिक्षा देते पाए जाते हैं।",
      ),
    ],
    'Sorrowful': [
      const MysteryModel(
        title: "बाग में पीड़ा",
        fruit: "पाप पर पश्चाताप",
        scripture: "लूका 22:44",
        description: "येसु गेधसमनी बाग में मृत्यु से पहले की रात प्रार्थना करते हैं।",
      ),
      const MysteryModel(
        title: "खंभे से बांधकर कोड़े",
        fruit: "पवित्रता",
        scripture: "यूहन्ना 19:1",
        description: "पिलातुस येसु को कोड़े मारने का आदेश देता है।",
      ),
      const MysteryModel(
        title: "कांटों का मुकुट",
        fruit: "साहस",
        scripture: "मत्ती 27:29",
        description: "सैनिक येसु को कांटों का मुकुट पहनाकर उनका उपहास करते हैं।",
      ),
      const MysteryModel(
        title: "क्रूस वहन",
        fruit: "धैर्य",
        scripture: "यूहन्ना 19:17",
        description: "येसु भारी क्रूस उठाकर कलवारी की ओर जाते हैं।",
      ),
      const MysteryModel(
        title: "क्रूस पर मृत्यु",
        fruit: "मोक्ष",
        scripture: "लूका 23:46",
        description: "येसु हमारे पापों के लिए क्रूस पर मरते हैं।",
      ),
    ],
    'Glorious': [
      const MysteryModel(
        title: "पुनरुत्थान",
        fruit: "विश्वास",
        scripture: "मरकुस 16:6",
        description: "येसु मृत्यु को जीतकर जी उठते हैं।",
      ),
      const MysteryModel(
        title: "स्वर्गारोहण",
        fruit: "आशा",
        scripture: "प्रेरितों 1:9",
        description: "येसु पिता के पास स्वर्ग में चले जाते हैं।",
      ),
      const MysteryModel(
        title: "पवित्र आत्मा का आगमन",
        fruit: "प्रज्ञा",
        scripture: "प्रेरितों 2:4",
        description: "पवित्र आत्मा प्रेरितों पर उतरता है।",
      ),
      const MysteryModel(
        title: "मरियम का स्वर्गारोहण",
        fruit: "भक्ति",
        scripture: "भजन 132:8",
        description: "मरियम शरीर और आत्मा सहित स्वर्ग में उठाई जाती हैं।",
      ),
      const MysteryModel(
        title: "मरियम का राज्याभिषेक",
        fruit: "अनन्त आनंद",
        scripture: "प्रका. 12:1",
        description: "मरियम को स्वर्ग और पृथ्वी की रानी घोषित किया जाता है।",
      ),
    ],
    'Luminous': [
      const MysteryModel(
        title: "बपतिस्मा",
        fruit: "खुलापन",
        scripture: "मत्ती 3:17",
        description: "ईश्वर येसु को अपना प्रिय पुत्र घोषित करते हैं।",
      ),
      const MysteryModel(
        title: "काना का विवाह",
        fruit: "मरियम के द्वारा येसु तक",
        scripture: "यूहन्ना 2:5",
        description: "येसु मरियम के अनुरोध पर पानी को दाखरस में बदलते हैं।",
      ),
      const MysteryModel(
        title: "राज्य की घोषणा",
        fruit: "पश्चाताप",
        scripture: "मरकुस 1:15",
        description: "येसु सुसमाचार का प्रचार करते और मन-फिराव के लिए बुलाते हैं।",
      ),
      const MysteryModel(
        title: "रूपान्तरण",
        fruit: "पवित्रता",
        scripture: "मत्ती 17:2",
        description: "येसु पेत्रुस, याकूब और यूहन्ना को महिमा में प्रकट होते हैं।",
      ),
      const MysteryModel(
        title: "पवित्र भोज की स्थापना",
        fruit: "आराधना",
        scripture: "लूका 22:19",
        description: "येसु अपने शरीर और रक्त को आत्माओं के भोजन के रूप में देते हैं।",
      ),
    ],
  };

  // ==============================================================================
  // 4. MYSTERIES (MALAYALAM)
  // ==============================================================================
  static final Map<String, List<MysteryModel>> _mysteriesMl = {
    'Joyful': [
      const MysteryModel(
        title: "മംഗളവാർത്ത",
        fruit: "താഴ്മ",
        scripture: "ലൂക്കാ 1:38",
        description: "ഗബ്രിയേൽ ദൂതൻ മറിയത്തെ സമീപിച്ച് ദൈവപുത്രന്റെ മാതാവാകുമെന്ന് അറിയിക്കുന്നു.",
      ),
      const MysteryModel(
        title: "സന്ദർശനം",
        fruit: "അയൽക്കാരോടുള്ള സ്നേഹം",
        scripture: "ലൂക്കാ 1:41",
        description: "മറിയം തന്റെ ചാർച്ചക്കാരിയായ എലിസബത്തിനെ സന്ദർശിക്കുന്നു.",
      ),
      const MysteryModel(
        title: "ഈശോയുടെ ജനനം",
        fruit: "ദാരിദ്ര്യം",
        scripture: "ലൂക്കാ 2:7",
        description: "ബെത്‌ലഹേമിലെ ഒരു കാലിത്തൊഴുത്തിൽ ഈശോ ജനിക്കുന്നു.",
      ),
      const MysteryModel(
        title: "കാഴ്ചയർപ്പണം",
        fruit: "അനുസരണം",
        scripture: "ലൂക്കാ 2:22",
        description: "മറിയവും യൗസേപ്പും ഈശോയെ ദൈവാലയത്തിൽ കാഴ്ചയർപ്പിക്കുന്നു.",
      ),
      const MysteryModel(
        title: "കണ്ടെത്തൽ",
        fruit: "ദൈവിക കാര്യങ്ങളിലുള്ള താല്പര്യം",
        scripture: "ലൂക്കാ 2:46",
        description: "കാണാതായ ഈശോയെ മാതാപിതാക്കൾ ദൈവാലയത്തിൽ കണ്ടെത്തുന്നു.",
      ),
    ],
    'Sorrowful': [
      const MysteryModel(
        title: "പൂങ്കാവനത്തിലെ പ്രാർത്ഥന",
        fruit: "പാപങ്ങളിലുള്ള പശ്ചാത്താപം",
        scripture: "ലൂക്കാ 22:44",
        description: "ഈശോ തന്റെ മരണത്തിന് മുൻപായി ഗത്സെമനി തോട്ടത്തിൽ പ്രാർത്ഥിക്കുന്നു.",
      ),
      const MysteryModel(
        title: "ചമ്മട്ടികളാലുള്ള അടി",
        fruit: "ശരീര ഇന്ദ്രിയങ്ങളുടെ അടക്കം",
        scripture: "യോഹന്നാൻ 19:1",
        description: "പീലാത്തോസിന്റെ കൽപനയാൽ ഈശോ ചമ്മട്ടിയാൽ അടിക്കപ്പെടുന്നു.",
      ),
      const MysteryModel(
        title: "മുൾമുടി ധриപ്പിക്കൽ",
        fruit: "അപമാനങ്ങളെ സഹിക്കാനുള്ള ശക്തി",
        scripture: "മത്തായി 27:29",
        description: "പടയാളികൾ ഈശോയെ പരിഹസിച്ച് മുൾമുടി ധരിപ്പിക്കുന്നു.",
      ),
      const MysteryModel(
        title: "കുരിശ് ചുമക്കൽ",
        fruit: "എളിമയോടെ കുരിശ് ചുമക്കൽ",
        scripture: "യോഹന്നാൻ 19:17",
        description: "ഈശോ കഠിനമായ കുരിശും ചുമന്ന് കൽവാരിയിലേക്ക് പോകുന്നു.",
      ),
      const MysteryModel(
        title: "കുരിശുമരണം",
        fruit: "ആത്മത്യാഗം",
        scripture: "ലൂക്കാ 23:46",
        description: "നമ്മുടെ പാപങ്ങൾക്ക് വേണ്ടി ഈശോ കുരിശിൽ മരിക്കുന്നു.",
      ),
    ],
    'Glorious': [
      const MysteryModel(
        title: "ഉയിർപ്പ്",
        fruit: "വിശ്വാസം",
        scripture: "മർക്കോസ് 16:6",
        description: "ഈശോ മരിച്ചവരിൽ നിന്ന് മഹത്വത്തോടെ ഉയിർത്തെഴുന്നള്ളുന്നു.",
      ),
      const MysteryModel(
        title: "സ്വർഗ്ഗാരോഹണം",
        fruit: "ശരണാശ",
        scripture: "അപ്പ.പ്ര 1:9",
        description: "ഈശോ തന്റെ പിതാവിന്റെ അടുത്തേക്ക് സ്വർഗ്ഗത്തിലേക്ക് എഴുന്നള്ളുന്നു.",
      ),
      const MysteryModel(
        title: "പരിശുദ്ധാത്മാവിന്റെ എഴുന്നള്ളത്ത്",
        fruit: "ദൈവസ്നേഹം",
        scripture: "അപ്പ.പ്ര 2:4",
        description: "പരിശുദ്ധാത്മാവ് ശ്ലീഹന്മാരുടെ മേൽ എഴുന്നള്ളി വരുന്നു.",
      ),
      const MysteryModel(
        title: "മാതാവിന്റെ സ്വർഗ്ഗാരോഹണം",
        fruit: "മാതാവിനോടുള്ള ഭക്തി",
        scripture: "സങ്കീർത്തനം 132:8",
        description: "കന്യകാമറിയം ആത്മാവോടും ശരീരത്തോടും കൂടെ സ്വർഗ്ഗത്തിലേക്ക് എടുക്കപ്പെടുന്നു.",
      ),
      const MysteryModel(
        title: "മാതാവിന്റെ കിരീടധാരണം",
        fruit: "സ്വർഗ്ഗീയ ഭാഗ്യം",
        scripture: "വെളിപാട് 12:1",
        description: "മറിയം സ്വർഗ്ഗത്തിന്റെയും ഭൂമിയുടെയും രാജ്ഞിയായി മുടി ധരിപ്പിക്കപ്പെടുന്നു.",
      ),
    ],
    'Luminous': [
      const MysteryModel(
        title: "മാമ്മോദീസ",
        fruit: "ദൈവഹിതത്തോടുള്ള വിശ്വസ്തത",
        scripture: "മത്തായി 3:17",
        description: "യോർദ്ദാൻ നദിയിൽ വെച്ച് ഈശോ മാമ്മോദീസ സ്വീകരിക്കുന്നു.",
      ),
      const MysteryModel(
        title: "കാനായിലെ വിവാഹം",
        fruit: "മറിയം വഴി ഈശോയിലേക്ക്",
        scripture: "യോഹന്നാൻ 2:5",
        description: "മറിയത്തിന്റെ അപേക്ഷ പ്രകാരം ഈശോ വെളളത്തെ വീഞ്ഞാക്കി മാറ്റുന്നു.",
      ),
      const MysteryModel(
        title: "ദൈവരാജ്യ പ്രഖ്യാപനം",
        fruit: "മാനസാന്തരം",
        scripture: "മർക്കോസ് 1:15",
        description: "ഈശോ സുവിശേഷം പ്രസംഗിക്കുകയും മാനസാന്തരപ്പെടാൻ ആവശ്യപ്പെടുകയും ചെയ്യുന്നു.",
      ),
      const MysteryModel(
        title: "രൂപാന്തരം",
        fruit: "ആത്മീയ ചൈതന്യം",
        scripture: "മത്തായി 17:2",
        description: "താബോർ മലയിൽ വെച്ച് ഈശോ മഹത്വപൂർണ്ണനായി രൂപം മാറുന്നു.",
      ),
      const MysteryModel(
        title: "വിശുദ്ധ കുർബാനയുടെ സ്ഥാപനം",
        fruit: "കൂദാശകളോടുള്ള ഭക്തി",
        scripture: "ലൂക്കാ 22:19",
        description: "വിശ്വാസികളുടെ ആത്മീയ ഭക്ഷണമായി ഈശോ വിശുദ്ധ കുർബാന സ്ഥാപിക്കുന്നു.",
      ),
    ],
  };

  // ==============================================================================
  // 3. PRAYERS (ENGLISH)
  // ==============================================================================
  static const Map<String, String> _prayersEn = {
    'Sign of the Cross':
        "In the name of the Father, and of the Son, and of the Holy Spirit. Amen.",
    'Apostles\' Creed':
        "I believe in God, the Father Almighty, Creator of heaven and earth...",
    'Our Father':
        "Our Father, who art in heaven, hallowed be Thy name; Thy kingdom come; Thy will be done on earth as it is in heaven. Give us this day our daily bread; and forgive us our trespasses as we forgive those who trespass against us; and lead us not into temptation, but deliver us from evil. Amen.",
    'Hail Mary':
        "Hail Mary, full of grace, the Lord is with thee. Blessed art thou among women, and blessed is the fruit of thy womb, Jesus. Holy Mary, Mother of God, pray for us sinners, now and at the hour of our death. Amen.",
    'Glory Be':
        "Glory be to the Father, and to the Son, and to the Holy Spirit. As it was in the beginning, is now, and ever shall be, world without end. Amen.",
    'Fatima Prayer':
        "O my Jesus, forgive us our sins, save us from the fires of hell, lead all souls to Heaven, especially those in most need of Thy mercy.",
    'Hail, Holy Queen':
        "Hail, holy Queen, Mother of mercy, hail, our life, our sweetness and our hope...",
  };

  // ==============================================================================
  // 4. PRAYERS (TAMIL)
  // ==============================================================================
  static const Map<String, String> _prayersTa = {
    'Sign of the Cross': "தந்தை, மகன், தூய ஆவியாரின் பெயராலே. ஆமென்.",
    'Apostles\' Creed':
        "விண்ணையும் மண்ணையும் படைத்த எல்லாம் வல்ல தந்தையாகிய கடவுளை நம்புகிறேன்...",
    'Our Father':
        "பரலோகத்தில் இருக்கிற எங்கள் பிதாவே, உம்முடைய நாமம் அர்ச்சிக்கப்படுவதாக; உம்முடைய இராச்சியம் வருக; உம்முடைய சித்தம் பரலோகத்தில் செய்யப்படுவது போல, பூலோகத்திலும் செய்யப்படுவதாக. \n\nஎங்கள் அனுதின உணவை எங்களுக்கு இன்று அளித்தருளும்; எங்களுக்குத் தீமை செய்தவர்களை நாங்கள் பொறுப்பதுபோல, எங்கள் பாவங்களைப் பொறுத்தருளும்; எங்களைச் சோதனையில் விழவிடாதேயும்; தீமையிலிருந்து எங்களை இரட்சித்தருளும். ஆமென்.",
    'Hail Mary':
        "அருள் நிறைந்த மரியே வாழ்க! கர்த்தர் உம்முடனே. பெண்களுக்குள் ஆசீர்வதிக்கப்பட்டவர் நீரே. உம்முடைய திருவயிற்றின் கனியாகிய இயேசுவும் ஆசீர்வதிக்கப்பட்டவரே. \n\nபுனித மரியே, இறைவனின் தாயே, பாவிகளாயிருக்கிற எங்களுக்காக இப்பொழுதும் எங்கள் இறப்பின் வேளையிலும் வேண்டிக்கொள்ளும். ஆமென்.",
    'Glory Be':
        "பிதாவுக்கும், சுதனுக்கும், பரிசுத்த ஆவிக்கும் மகிமை உண்டாவதாக. \n\nஆதியிலே இருந்ததுபோல இப்பொழுதும் எப்பொழுதும் என்றென்றும் இருப்பதாக. ஆமென்.",
    'Fatima Prayer':
        "ஓ என் இயேசுவே! எங்கள் பாவங்களை மன்னியும். நரக நெருப்பிலிருந்து எங்களை மீட்டருளும். எல்லாரையும் விண்ணகப் பாதையில் நடத்தியருளும். உமது இரக்கம் யாருக்கு அதிகம் தேவையோ, அவர்களுக்குச் சிறப்பான உதவி புரியும்.",
    'Hail, Holy Queen':
        "வாழ்க அரசியே! தயை மிக்க அன்னையே வாழ்க! எங்கள் வாழ்வே, இனிமையே, தஞ்சமே வாழ்க!...",
  };

  // --- PUBLIC GETTER ---
  static Map<String, String> getPrayers(String lang) {
    if (lang == 'ta') return _prayersTa;
    if (lang == 'hi') return _prayersHi;
    if (lang == 'ml') return _prayersMl;
    return _prayersEn;
  }

  // ==============================================================================
  // 5. PRAYERS (MALAYALAM)
  // ==============================================================================
  static const Map<String, String> _prayersMl = {
    'Sign of the Cross': "പിതാവിന്റെയും പുത്രന്റെയും പരിശുദ്ധാത്മാവിന്റെയും നാമത്തിൽ. ആമേൻ.",
    'Apostles\' Creed':
        "സർവ്വരാധിപതിയായ പിതാവും ആകാശത്തിന്റെയും ഭൂമിയുടെയും സ്രഷ്ടാവുമായ ദൈവത്തിൽ ഞാൻ വിശ്വസിക്കുന്നു. അവിടുത്തെ ഏകപുത്രനും നമ്മുടെ കർത്താവുമായ ഈശോമിശിഹായിലും ഞാൻ വിശ്വസിക്കുന്നു...",
    'Our Father':
        "സ്വർഗ്ഗസ്ഥനായ ഞങ്ങളുടെ പിതാവേ, അങ്ങയുടെ നാമം പൂജിതമാകണമേ. അങ്ങയുടെ രാജ്യം വരണമേ. അങ്ങയുടെ തിരുമനസ്സ് സ്വർഗ്ഗത്തിലെപ്പോലെ ഭൂമിയിലുമാകണമേ. \n\nഅന്നന്നു വേണ്ട ആഹാരം ഇന്ന് ഞങ്ങൾക്ക് നൽകണമേ. ഞങ്ങളോട് തെറ്റ് ചെയ്യുന്നവരോട് ഞങ്ങൾ ക്ഷമിക്കുന്നതുപോലെ, ഞങ്ങളുടെ തെറ്റുകൾ ഞങ്ങളോട് ക്ഷമിക്കണമേ. ഞങ്ങളെ പ്രലോഭനങ്ങളിൽ ഉൾപ്പെടുത്തരുതേ. തിന്മയിൽ നിന്ന് ഞങ്ങളെ കാത്തുകൊള്ളണമേ. ആമേൻ.",
    'Hail Mary':
        "നന്മ നിറഞ്ഞ മറിയമേ നിനക്ക് സ്വസ്തി, കർത്താവ് നിന്നോടുകൂടി. സ്ത്രീകളിൽ നീ അനുഗ്രഹിക്കപ്പെട്ടവളാകുന്നു, നിന്റെ ഉദരഫലമായ ഈശോയും അനുഗ്രഹിക്കപ്പെട്ടവനാകുന്നു. \n\nപരിശുദ്ധ മറിയമേ തമ്പുരാന്റെ അമ്മേ, പാപികളായ ഞങ്ങൾക്കുവേണ്ടി ഇപ്പോഴും ഞങ്ങളുടെ മരണസമയത്തും തമ്പുരാനോട് അപേക്ഷിക്കണമേ. ആമേൻ.",
    'Glory Be':
        "പിതാവിനും പുത്രനും പരിശുദ്ധാത്മാവിനും സ്തുതി. \n\nആദിയിലെപ്പോലെ ഇപ്പോഴും എപ്പോഴും എന്നേക്കും. ആമേൻ.",
    'Fatima Prayer':
        "ഓ എന്റെ ഈശോയെ, ഞങ്ങളുടെ പാപങ്ങൾ ക്ഷമിക്കണമേ. നരകാഗ്നിയിൽ നിന്ന് ഞങ്ങളെ രക്ഷിക്കണമേ. എല്ലാ ആത്മാക്കളെയും, പ്രത്യേകിച്ച് അങ്ങയുടെ സഹായം കൂടുതൽ ആവശ്യമുള്ളവരേയും സ്വർഗ്ഗത്തിലേക്ക് ആനയിക്കണമേ.",
    'Hail, Holy Queen':
        "പരിശുദ്ധ രാജ്ഞീ, കരുണയുള്ള മാതാവേ സ്വസ്തി! ഞങ്ങളുടെ ജീവനും മാധുര്യവും ശരണവുമേ സ്വസ്തി!...",
  };

  // ==============================================================================
  // 5. PRAYERS (HINDI)
  // ==============================================================================
  static const Map<String, String> _prayersHi = {
    'Sign of the Cross': "पिता, पुत्र और पवित्र आत्मा के नाम में। आमीन।",
    'Apostles\' Creed':
        "मैं सर्वशक्तिमान पिता ईश्वर पर विश्वास करता हूँ, स्वर्ग और पृथ्वी के सृष्टिकर्ता पर...",
    'Our Father':
        "हे हमारे स्वर्गीय पिता, तेरा नाम पवित्र हो; तेरा राज्य आए; तेरी इच्छा जैसी स्वर्ग में पूरी होती है, वैसे पृथ्वी पर भी हो। \n\nहमारी प्रतिदिन की रोटी आज हमें दे; और हमारे अपराधों को क्षमा कर, जैसे हम भी अपने अपराधियों को क्षमा करते हैं; और हमें परीक्षा में न ले, परन्तु बुराई से बचा। आमीन।",
    'Hail Mary':
        "हे मरियम, अनुग्रह से परिपूर्ण, प्रभु तेरे साथ है। तू स्त्रियों में धन्य है, और धन्य है तेरे उदर का फल येसु। \n\nहे पवित्र मरियम, ईश्वर की माँ, अभी और हमारी मृत्यु की घड़ी में हम पापियों के लिए प्रार्थना कर। आमीन।",
    'Glory Be':
        "पिता को, पुत्र को और पवित्र आत्मा को महिमा हो। \n\nजैसे आदि में थी, अब है और सदा रहेगी, युगों युग। आमीन।",
    'Fatima Prayer':
        "हे मेरे येसु, हमारे पापों को क्षमा कर, हमें नरक की आग से बचा, सभी आत्माओं को स्वर्ग ले चल, विशेषकर उन आत्माओं को जिन्हें तेरी दया की सबसे अधिक आवश्यकता है।",
    'Hail, Holy Queen':
        "हे पवित्र रानी, दया की माँ, हमारा जीवन, मिठास और आशा...",
  };
}
