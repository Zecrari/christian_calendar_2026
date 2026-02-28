import 'models.dart';

class SaintsDatabase {
  static SaintModel getSaint(int month, int day, String lang) {
    final String key = "$month-$day";

    // 1. CHECK MAJOR FEASTS (Full Manual Data)
    // If it's a major feast, we have the full translation ready.
    if (_majorFeastIDs.containsKey(key)) {
      final String id = _majorFeastIDs[key]!;
      final dataMap = (lang == 'ta')
          ? _majorSaintsTa
          : (lang == 'hi')
              ? _majorSaintsHi
              : (lang == 'ml')
                  ? _majorSaintsMl
                  : _majorSaintsEn;

      if (dataMap.containsKey(id)) {
        return dataMap[id]!;
      }
    }

    // 2. DETERMINE THE SAINT'S NAME
    String name;

    if (lang == 'ta' && _dailyNamesTa.containsKey(key)) {
      name = _dailyNamesTa[key]!;
    } else if (lang == 'hi' && _dailyNamesHi.containsKey(key)) {
      name = _dailyNamesHi[key]!;
    } else if (lang == 'ml' && _dailyNamesMl.containsKey(key)) {
      name = _dailyNamesMl[key]!;
    } else if (_dailyNamesEn.containsKey(key)) {
      name = _dailyNamesEn[key]!;
    } else {
      name = (lang == 'ta')
          ? "இன்றைய புனிதர்"
          : (lang == 'hi')
              ? "आज के संत"
              : (lang == 'ml')
                  ? "ഇന്നത്തെ വിശുദ്ധൻ"
                  : "Saint of the Day";
    }

    // 3. GENERATE CONTENT IN THE CORRECT LANGUAGE
    // This fixes the bug. We force the generator to use 'lang',
    // even if the name we found was English.
    return _generateDailySaint(name, lang);
  }

  // (Ensure your _generateDailySaint method is defined like this)
  static SaintModel _generateDailySaint(String name, String lang) {
    if (lang == 'ta') {
      return SaintModel(
        name: name,
        bio:
            "இன்று திருச்சபை $name அவர்களை நினைவு கூர்கிறது. இவரது விசுவாச வாழ்வு நமக்கு ஒரு சிறந்த எடுத்துக்காட்டாகும்.",
        prayer:
            "இறைவா, $name அவர்களின் பரிந்துரையால் எங்கள் அன்றாட வாழ்வில் உமது சாட்சிகளாக வாழ அருள்புரியும். ஆமேன்.",
        isMajorFeast: false,
      );
    } else if (lang == 'hi') {
      return SaintModel(
        name: name,
        bio:
            "आज किर्मल $name का स्मरण करती है। उनका विश्वास का जीवन हमारे लिए अनुकरणीय उदाहरण है।",
        prayer:
            "हे ईश्वर, $name की शिक्षा से हमें प्रेरित कर। आमीन।",
        isMajorFeast: false,
      );
    } else if (lang == 'ml') {
      return SaintModel(
        name: name,
        bio:
            "ഇന്ന് സഭ $name പുണ്യവാളനെ ഓർക്കുന്നു. അദ്ദേഹത്തിന്റെ ക്രിസ്തീയ ജീവിതം നമുക്ക് ഒരു നല്ല മാതൃകയാണ്.",
        prayer:
            "ദൈവമേ, $name -ന്റെ മാധ്യസ്ഥത്താൽ ഞങ്ങളെ അനുഗ്രഹിക്കണമേ. ആമേൻ.",
        isMajorFeast: false,
      );
    } else {
      return SaintModel(
        name: name,
        bio:
            "Today the Church celebrates the memory of $name. Their life stands as a testament to the power of faith and God's grace.",
        prayer:
            "Lord God, You gave us $name as an example of holiness. Help us to follow in their footsteps. Amen.",
        isMajorFeast: false,
      );
    }
  }

  // ==========================================================
  // 1. MAJOR FEAST MAPPING (The "Gold Border" Days)
  // ==========================================================
  static final Map<String, String> _majorFeastIDs = {
    "1-1": "MaryMother",
    "1-6": "Epiphany",
    "3-19": "Joseph",
    "3-25": "Annunciation",
    "4-23": "George",
    "5-1": "JosephWorker",
    "6-13": "Anthony",
    "6-24": "JohnBaptist",
    "6-29": "PeterPaul",
    "7-3": "Thomas",
    "7-22": "Magdalene",
    "7-31": "Ignatius",
    "8-15": "Assumption",
    "9-5": "MotherTeresa",
    "9-8": "MaryBirth",
    "9-29": "Archangels",
    "10-1": "Therese",
    "10-2": "GuardianAngels",
    "10-4": "Francis",
    "11-1": "AllSaints",
    "11-2": "AllSouls",
    "12-3": "Xavier",
    "12-8": "Immaculate",
    "12-25": "Christmas",
    "12-26": "Stephen",
    "12-27": "JohnAp",
    "12-28": "Innocents",
    "12-31": "Sylvester",
  };

  // ==========================================================
  // 2. DAILY NAMES MAP (English) - COVERS 365 DAYS
  // ==========================================================
  static final Map<String, String> _dailyNamesEn = {
    // JAN
    "1-1": "Mary, Mother of God",
    "1-2": "St. Basil & St. Gregory",
    "1-3": "Most Holy Name of Jesus",
    "1-4": "St. Elizabeth Ann Seton",
    "1-5": "St. John Neumann",
    "1-6": "The Epiphany",
    "1-7": "St. Raymond of Penyafort",
    "1-8": "St. Angela of Foligno",
    "1-9": "St. Adrian of Canterbury",
    "1-10": "St. Gregory of Nyssa",
    "1-11": "Bl. William Carter",
    "1-12": "St. Marguerite Bourgeoys",
    "1-13": "St. Hilary of Poitiers",
    "1-14": "St. Felix of Nola",
    "1-15": "St. Paul the Hermit",
    "1-16": "St. Berard & Comp.",
    "1-17": "St. Anthony the Abbot",
    "1-18": "St. Margaret of Hungary",
    "1-19": "St. Fabian",
    "1-20": "St. Sebastian",
    "1-21": "St. Agnes",
    "1-22": "St. Vincent Pallotti",
    "1-23": "St. Marianne Cope",
    "1-24": "St. Francis de Sales",
    "1-25": "Conversion of St. Paul",
    "1-26": "Sts. Timothy & Titus",
    "1-27": "St. Angela Merici",
    "1-28": "St. Thomas Aquinas",
    "1-29": "St. Gildas",
    "1-30": "St. Hyacintha Mariscotti",
    "1-31": "St. John Bosco",

    // FEB
    "2-1": "St. Brigid of Ireland",
    "2-2": "Presentation of the Lord",
    "2-3": "St. Blaise",
    "2-4": "St. John de Britto",
    "2-5": "St. Agatha",
    "2-6": "St. Paul Miki & Comp.",
    "2-7": "St. Colette",
    "2-8": "St. Josephine Bakhita",
    "2-9": "St. Apollonia",
    "2-10": "St. Scholastica",
    "2-11": "Our Lady of Lourdes",
    "2-12": "St. Apollonius",
    "2-13": "St. Catherine de Ricci",
    "2-14": "Sts. Cyril & Methodius",
    "2-15": "St. Claude de la Colombière",
    "2-16": "St. Juliana",
    "2-17": "Seven Founders of Servites",
    "2-18": "St. Bernadette Soubirous",
    "2-19": "St. Conrad",
    "2-20": "Sts. Jacinta & Francisco",
    "2-21": "St. Peter Damian",
    "2-22": "Chair of St. Peter",
    "2-23": "St. Polycarp",
    "2-24": "Bl. Luke Belludi",
    "2-25": "St. Walburga",
    "2-26": "St. Paula",
    "2-27": "St. Gabriel of Our Lady",
    "2-28": "St. Romanus",
    "2-29": "St. Oswald",

    // MAR
    "3-1": "St. David of Wales",
    "3-2": "St. Agnes of Bohemia",
    "3-3": "St. Katharine Drexel",
    "3-4": "St. Casimir",
    "3-5": "St. John Joseph",
    "3-6": "St. Colette",
    "3-7": "Sts. Perpetua & Felicity",
    "3-8": "St. John of God",
    "3-9": "St. Frances of Rome",
    "3-10": "St. Dominic Savio",
    "3-11": "St. Constantine",
    "3-12": "St. Luigi Orione",
    "3-13": "St. Leander",
    "3-14": "St. Maximilian",
    "3-15": "St. Louise de Marillac",
    "3-16": "St. Clement Mary Hofbauer",
    "3-17": "St. Patrick",
    "3-18": "St. Cyril of Jerusalem",
    "3-19": "St. Joseph",
    "3-20": "St. Salvator",
    "3-21": "St. Nicholas of Flue",
    "3-22": "St. Lea",
    "3-23": "St. Turibius",
    "3-24": "St. Oscar Romero",
    "3-25": "Annunciation of the Lord",
    "3-26": "St. Margaret Clitherow",
    "3-27": "St. Rupert",
    "3-28": "St. Guntram",
    "3-29": "St. Berthold",
    "3-30": "St. Peter Regalado",
    "3-31": "St. Benjamin",

    // APR
    "4-1": "St. Hugh of Grenoble",
    "4-2": "St. Francis of Paola",
    "4-3": "St. Richard",
    "4-4": "St. Isidore",
    "4-5": "St. Vincent Ferrer",
    "4-6": "St. Crescentia",
    "4-7": "St. John Baptist de la Salle",
    "4-8": "St. Julie Billiart",
    "4-9": "St. Waldetrudis",
    "4-10": "St. Magdalen",
    "4-11": "St. Stanislaus",
    "4-12": "St. Teresa of Andes",
    "4-13": "St. Martin I",
    "4-14": "St. Lydwine",
    "4-15": "St. Hunna",
    "4-16": "St. Bernadette",
    "4-17": "St. Benedict Joseph Labre",
    "4-18": "St. Perfectus",
    "4-19": "St. Gianna Molla",
    "4-20": "St. Conrad",
    "4-21": "St. Anselm",
    "4-22": "St. Adalbert",
    "4-23": "St. George",
    "4-24": "St. Fidelis",
    "4-25": "St. Mark the Evangelist",
    "4-26": "Our Lady of Good Counsel",
    "4-27": "St. Zita",
    "4-28": "St. Louis de Montfort",
    "4-29": "St. Catherine of Siena",
    "4-30": "St. Pius V",

    // MAY
    "5-1": "St. Joseph the Worker",
    "5-2": "St. Athanasius",
    "5-3": "Sts. Philip & James",
    "5-4": "St. Florian",
    "5-5": "St. Hilary of Arles",
    "5-6": "St. Dominic Savio",
    "5-7": "St. Rose Venerini",
    "5-8": "St. Peter of Tarentaise",
    "5-9": "St. Pachomius",
    "5-10": "St. Damien of Molokai",
    "5-11": "St. Ignatius of Laconi",
    "5-12": "Sts. Nereus & Achilleus",
    "5-13": "Our Lady of Fatima",
    "5-14": "St. Matthias",
    "5-15": "St. Isidore the Farmer",
    "5-16": "St. Simon Stock",
    "5-17": "St. Paschal Baylon",
    "5-18": "St. John I",
    "5-19": "St. Ivo",
    "5-20": "St. Bernardine of Siena",
    "5-21": "St. Christopher Magallanes",
    "5-22": "St. Rita of Cascia",
    "5-23": "St. John Baptist de Rossi",
    "5-24": "Mary, Help of Christians",
    "5-25": "St. Bede the Venerable",
    "5-26": "St. Philip Neri",
    "5-27": "St. Augustine of Canterbury",
    "5-28": "Bl. Margaret Pole",
    "5-29": "St. Paul VI",
    "5-30": "St. Joan of Arc",
    "5-31": "Visitation of Mary",

    // JUN
    "6-1": "St. Justin Martyr",
    "6-2": "Sts. Marcellinus & Peter",
    "6-3": "St. Charles Lwanga",
    "6-4": "St. Francis Caracciolo",
    "6-5": "St. Boniface",
    "6-6": "St. Norbert",
    "6-7": "St. Robert",
    "6-8": "St. Medard",
    "6-9": "St. Ephrem",
    "6-10": "Bl. Joachina",
    "6-11": "St. Barnabas",
    "6-12": "St. Gaspar",
    "6-13": "St. Anthony of Padua",
    "6-14": "St. Albert",
    "6-15": "St. Germaine",
    "6-16": "St. John Francis Regis",
    "6-17": "St. Joseph Cafasso",
    "6-18": "St. Gregory Barbarigo",
    "6-19": "St. Romuald",
    "6-20": "St. Silverius",
    "6-21": "St. Aloysius Gonzaga",
    "6-22": "Sts. Thomas More & John Fisher",
    "6-23": "St. Joseph Cafasso",
    "6-24": "Nativity of John the Baptist",
    "6-25": "St. William",
    "6-26": "St. Josemaria Escriva",
    "6-27": "St. Cyril of Alexandria",
    "6-28": "St. Irenaeus",
    "6-29": "Sts. Peter & Paul",
    "6-30": "First Martyrs of Rome",

    // JUL
    "7-1": "St. Junipero Serra",
    "7-2": "St. Oliver Plunkett",
    "7-3": "St. Thomas the Apostle",
    "7-4": "St. Elizabeth of Portugal",
    "7-5": "St. Anthony Zaccaria",
    "7-6": "St. Maria Goretti",
    "7-7": "Bl. Peter To Rot",
    "7-8": "St. Gregory Grassi",
    "7-9": "St. Augustine Zhao Rong",
    "7-10": "St. Veronica Giuliani",
    "7-11": "St. Benedict",
    "7-12": "Sts. Louis & Zelie Martin",
    "7-13": "St. Henry",
    "7-14": "St. Kateri Tekakwitha",
    "7-15": "St. Bonaventure",
    "7-16": "Our Lady of Mount Carmel",
    "7-17": "St. Alexius",
    "7-18": "St. Camillus de Lellis",
    "7-19": "St. Arsenius",
    "7-20": "St. Apollinaris",
    "7-21": "St. Lawrence of Brindisi",
    "7-22": "St. Mary Magdalene",
    "7-23": "St. Bridget of Sweden",
    "7-24": "St. Sharbel Makhluf",
    "7-25": "St. James the Apostle",
    "7-26": "Sts. Joachim & Anne",
    "7-27": "St. Titus Brandsma",
    "7-28": "St. Alphonsa",
    "7-29": "Sts. Martha, Mary & Lazarus",
    "7-30": "St. Peter Chrysologus",
    "7-31": "St. Ignatius of Loyola",

    // AUG
    "8-1": "St. Alphonsus Liguori",
    "8-2": "St. Peter Julian Eymard",
    "8-3": "St. Lydia",
    "8-4": "St. John Vianney",
    "8-5": "Dedication of St. Mary Major",
    "8-6": "Transfiguration of the Lord",
    "8-7": "St. Cajetan",
    "8-8": "St. Dominic",
    "8-9": "St. Teresa Benedicta",
    "8-10": "St. Lawrence",
    "8-11": "St. Clare of Assisi",
    "8-12": "St. Jane Frances de Chantal",
    "8-13": "St. Pontian & Hippolytus",
    "8-14": "St. Maximilian Kolbe",
    "8-15": "Assumption of Mary",
    "8-16": "St. Stephen of Hungary",
    "8-17": "St. Joan of the Cross",
    "8-18": "St. Helena",
    "8-19": "St. John Eudes",
    "8-20": "St. Bernard of Clairvaux",
    "8-21": "St. Pius X",
    "8-22": "Queenship of Mary",
    "8-23": "St. Rose of Lima",
    "8-24": "St. Bartholomew",
    "8-25": "St. Louis of France",
    "8-26": "Our Lady of Czestochowa",
    "8-27": "St. Monica",
    "8-28": "St. Augustine",
    "8-29": "Passion of John the Baptist",
    "8-30": "St. Jeanne Jugan",
    "8-31": "Sts. Joseph of Arimathea",

    // SEP
    "9-1": "St. Giles",
    "9-2": "Bl. John Francis Burte",
    "9-3": "St. Gregory the Great",
    "9-4": "St. Rosalia",
    "9-5": "St. Teresa of Calcutta",
    "9-6": "St. Eleutherius",
    "9-7": "Bl. Frederic Ozanam",
    "9-8": "Nativity of Mary",
    "9-9": "St. Peter Claver",
    "9-10": "St. Nicholas of Tolentino",
    "9-11": "St. John Gabriel Perboyre",
    "9-12": "Most Holy Name of Mary",
    "9-13": "St. John Chrysostom",
    "9-14": "Exaltation of the Holy Cross",
    "9-15": "Our Lady of Sorrows",
    "9-16": "St. Cornelius",
    "9-17": "St. Robert Bellarmine",
    "9-18": "St. Joseph of Cupertino",
    "9-19": "St. Januarius",
    "9-20": "St. Andrew Kim Taegon",
    "9-21": "St. Matthew the Apostle",
    "9-22": "St. Lorenzo Ruiz",
    "9-23": "St. Pio of Pietrelcina",
    "9-24": "Our Lady of Walsingham",
    "9-25": "St. Finbar",
    "9-26": "Sts. Cosmas & Damian",
    "9-27": "St. Vincent de Paul",
    "9-28": "St. Wenceslaus",
    "9-29": "Sts. Michael, Gabriel & Raphael",
    "9-30": "St. Jerome",

    // OCT
    "10-1": "St. Therese of Lisieux",
    "10-2": "Holy Guardian Angels",
    "10-3": "St. Theodora Guerin",
    "10-4": "St. Francis of Assisi",
    "10-5": "St. Faustina Kowalska",
    "10-6": "St. Bruno",
    "10-7": "Our Lady of the Rosary",
    "10-8": "St. Pelagia",
    "10-9": "St. John Leonardi",
    "10-10": "St. Francis Borgia",
    "10-11": "St. John XXIII",
    "10-12": "Bl. Carlo Acutis",
    "10-13": "St. Edward the Confessor",
    "10-14": "St. Callistus I",
    "10-15": "St. Teresa of Avila",
    "10-16": "St. Margaret Mary Alacoque",
    "10-17": "St. Ignatius of Antioch",
    "10-18": "St. Luke the Evangelist",
    "10-19": "Sts. John de Brebeuf & Isaac Jogues",
    "10-20": "St. Paul of the Cross",
    "10-21": "St. Hilarion",
    "10-22": "St. John Paul II",
    "10-23": "St. John of Capistrano",
    "10-24": "St. Anthony Claret",
    "10-25": "St. Crispin",
    "10-26": "St. Peter of Alcantara",
    "10-27": "St. Evaristus",
    "10-28": "Sts. Simon & Jude",
    "10-29": "St. Narcissus",
    "10-30": "St. Alphonsus Rodriguez",
    "10-31": "St. Wolfgang",

    // NOV
    "11-1": "All Saints Day",
    "11-2": "All Souls Day",
    "11-3": "St. Martin de Porres",
    "11-4": "St. Charles Borromeo",
    "11-5": "St. Elizabeth",
    "11-6": "St. Leonard",
    "11-7": "St. Didacus",
    "11-8": "Bl. John Duns Scotus",
    "11-9": "Dedication of Lateran Basilica",
    "11-10": "St. Leo the Great",
    "11-11": "St. Martin of Tours",
    "11-12": "St. Josaphat",
    "11-13": "St. Frances Xavier Cabrini",
    "11-14": "St. Lawrence O'Toole",
    "11-15": "St. Albert the Great",
    "11-16": "St. Margaret of Scotland",
    "11-17": "St. Elizabeth of Hungary",
    "11-18": "Dedication of Peter & Paul Basilicas",
    "11-19": "St. Matilda",
    "11-20": "St. Edmund",
    "11-21": "Presentation of Mary",
    "11-22": "St. Cecilia",
    "11-23": "St. Clement I",
    "11-24": "St. Andrew Dung-Lac",
    "11-25": "St. Catherine of Alexandria",
    "11-26": "St. John Berchmans",
    "11-27": "Our Lady of Miraculous Medal",
    "11-28": "St. Catherine Laboure",
    "11-29": "St. Saturninus",
    "11-30": "St. Andrew the Apostle",

    // DEC
    "12-1": "St. Charles de Foucauld",
    "12-2": "St. Bibiana",
    "12-3": "St. Francis Xavier",
    "12-4": "St. John Damascene",
    "12-5": "St. Sabas",
    "12-6": "St. Nicholas",
    "12-7": "St. Ambrose",
    "12-8": "Immaculate Conception",
    "12-9": "St. Juan Diego",
    "12-10": "Our Lady of Loreto",
    "12-11": "St. Damasus I",
    "12-12": "Our Lady of Guadalupe",
    "12-13": "St. Lucy",
    "12-14": "St. John of the Cross",
    "12-15": "St. Mary di Rosa",
    "12-16": "St. Adelaide",
    "12-17": "St. Lazarus",
    "12-18": "St. Malachy",
    "12-19": "St. Anastasius",
    "12-20": "St. Dominic of Silos",
    "12-21": "St. Peter Canisius",
    "12-22": "St. Frances Cabrini",
    "12-23": "St. John of Kanty",
    "12-24": "Christmas Eve",
    "12-25": "Nativity of the Lord",
    "12-26": "St. Stephen",
    "12-27": "St. John the Evangelist",
    "12-28": "Holy Innocents",
    "12-29": "St. Thomas Becket",
    "12-30": "Holy Family",
    "12-31": "St. Sylvester",
  };

  // ==========================================================
  // 3. DAILY NAMES MAP (Tamil) - COVERS 365 DAYS
  // ==========================================================
  static final Map<String, String> _dailyNamesTa = {
    // TAMIL DATA - KEY DATES (Others will fallback to English or translated manually here)
    // JAN
    "1-1": "இறைவனின் தாய் மரியா",
    "1-2": "புனித பேசில் & கிரகோரி",
    "1-3": "இயேசுவின் திருநாமம்",
    "1-4": "புனித எலிசபெத் ஆன் சீட்டன்",
    "1-5": "புனித ஜான் நியூமன்",
    "1-6": "திருக்காட்சி பெருவிழா",
    "1-17": "புனித அந்தோனியார் (வனவாசி)",
    "1-20": "புனித செபஸ்தியார்",
    "1-21": "புனித ஆக்னஸ்",
    "1-24": "புனித பிரான்சிஸ் டி சேல்ஸ்",
    "1-25": "புனித பவுல் மனமாற்றம்",
    "1-26": "திமோத்தேயு & தீத்து",
    "1-28": "புனித தாமஸ் அக்குவைனார்",
    "1-31": "புனித ஜான் போஸ்கோ",
    // FEB
    "2-2": "ஆண்டவர் காணிக்கை விழா",
    "2-5": "புனித அகத்தா",
    "2-6": "புனித பவுல் மிக்கி",
    "2-11": "லூர்து அன்னை",
    "2-14": "புனித வேலண்டைன்",
    "2-22": "பேதுருவின் தலைமை இருக்கை",
    // MAR
    "3-17": "புனித பாட்ரிக்",
    "3-19": "புனித யோசேப்பு",
    "3-25": "மங்கள வார்த்தை விழா",
    // APR
    "4-23": "புனித ஜார்ஜ்", "4-25": "புனித மாற்கு", "4-29": "புனித கேத்தரின்",
    // MAY
    "5-1": "புனித யோசேப்பு (தொழிலாளி)",
    "5-13": "பாத்திமா அன்னை",
    "5-31": "சந்திப்பு விழா",
    // JUN
    "6-13": "புனித அந்தோனியார்",
    "6-24": "திருமுழுக்கு யோவான்",
    "6-29": "பேதுரு & பவுல்",
    // JUL
    "7-3": "புனித தோமையார்",
    "7-22": "புனித மகதலா மரியா",
    "7-25": "புனித யாக்கோபு",
    "7-26": "சுவக்கின் & அன்னாள்",
    "7-31": "புனித லயோலா இக்னேசியஸ்",
    // AUG
    "8-4": "புனித ஜான் மரிய வியன்னி",
    "8-10": "புனித லாரன்ஸ்",
    "8-11": "புனித கிளாரா",
    "8-15": "விண்ணேற்பு விழா",
    "8-27": "புனித மோனிக்கா",
    "8-28": "புனித அகஸ்டின்",
    // SEP
    "9-5": "புனித அன்னை தெரசா",
    "9-8": "மாதா பிறந்த நாள்",
    "9-15": "வியாகுல அன்னை",
    "9-21": "புனித மத்தேயு",
    "9-23": "புனித பியோ",
    "9-27": "புனித வின்சென்ட் தே பவுல்",
    "9-29": "தலைமை தூதர்கள்",
    // OCT
    "10-1": "புனித குழந்தை தெரசா",
    "10-2": "காவல் தூதர்கள்",
    "10-4": "புனித பிரான்சிஸ் அசிசி",
    "10-7": "ஜெபமாலை அன்னை",
    "10-15": "புனித அவிலா தெரசா",
    "10-18": "புனித லூக்கா",
    "10-22": "புனித ஜான் பால் II",
    "10-28": "சீமோன் & யூதா ததேயு",
    // NOV
    "11-1": "சகல புனிதர்கள்",
    "11-2": "சகல ஆன்மாக்கள்",
    "11-3": "புனித மார்ட்டின் டி போர்ஸ்",
    "11-22": "புனித செசிலியா",
    "11-30": "புனித அந்திரேயா",
    // DEC
    "12-3": "புனித பிரான்சிஸ் சவேரியார்",
    "12-6": "புனித நிக்கோலஸ்",
    "12-8": "அமல உற்பவம்",
    "12-12": "குவாதலூபே அன்னை",
    "12-13": "புனித லூசியா",
    "12-25": "கிறிஸ்து பிறப்பு",
    "12-26": "புனித ஸ்தேவான்",
    "12-27": "புனித யோவான்",
    "12-28": "மாசற்ற குழந்தைகள்",
    "12-31": "புனித சில்வெஸ்டர்",
  };

  // ==========================================================
  // 4. MAJOR SAINTS DATA (Detailed English)
  // ==========================================================
  static final Map<String, SaintModel> _majorSaintsEn = {
    "MaryMother": SaintModel(
      name: "Mary, Mother of God",
      bio: "The Theotokos. We begin the year honoring the Mother of Jesus.",
      prayer: "Holy Mary, Mother of God, pray for us sinners.",
      isMajorFeast: true,
    ),
    "Joseph": SaintModel(
      name: "St. Joseph",
      bio: "Spouse of the Virgin Mary and Guardian of the Redeemer.",
      prayer: "St. Joseph, protect our families.",
      isMajorFeast: true,
    ),
    "George": SaintModel(
      name: "St. George",
      bio: "Martyr and soldier. Famous for the legend of slaying the dragon.",
      prayer: "Lord, grant us courage to fight evil.",
      isMajorFeast: true,
    ),
    "Anthony": SaintModel(
      name: "St. Anthony of Padua",
      bio: "Priest and Doctor of the Church. Patron of lost things.",
      prayer: "St. Anthony, help us find our way to God.",
      isMajorFeast: true,
    ),
    "Thomas": SaintModel(
      name: "St. Thomas the Apostle",
      bio: "The Apostle of India. He proclaimed 'My Lord and My God!'.",
      prayer: "Lord, increase our faith.",
      isMajorFeast: true,
    ),
    "MotherTeresa": SaintModel(
      name: "St. Teresa of Calcutta",
      bio:
          "Founder of Missionaries of Charity. Served the poorest of the poor.",
      prayer: "Lord, help us see You in the distressed.",
      isMajorFeast: true,
    ),
    "Francis": SaintModel(
      name: "St. Francis of Assisi",
      bio: "Lover of poverty and nature. Founder of the Franciscans.",
      prayer: "Lord, make me an instrument of your peace.",
      isMajorFeast: true,
    ),
    "Xavier": SaintModel(
      name: "St. Francis Xavier",
      bio: "Patron of Missions. Great evangelist of Asia.",
      prayer: "Lord, give us zeal for souls.",
      isMajorFeast: true,
    ),
    "Christmas": SaintModel(
      name: "Nativity of the Lord",
      bio: "The Word became flesh and dwelt among us.",
      prayer: "Glory to God in the highest.",
      isMajorFeast: true,
    ),
    "Immaculate": SaintModel(
      name: "Immaculate Conception",
      bio: "Mary was conceived without original sin.",
      prayer: "O Mary, conceived without sin, pray for us.",
      isMajorFeast: true,
    ),
    // ... You can add more detailed ones here over time
  };

  // ==========================================================
  // 5. MAJOR SAINTS DATA (Detailed Tamil)
  // ==========================================================
  static final Map<String, SaintModel> _majorSaintsTa = {
    "MaryMother": SaintModel(
      name: "இறைவனின் தாய் மரியா",
      bio:
          "இயேசுவின் தாய். புத்தாண்டின் துவக்கத்தில் அன்னையின் பாதுகாப்பை நாடுவோம்.",
      prayer: "புனித மரியே, இறைவனின் தாயே, எங்களுக்காக வேண்டிக்கொள்ளும்.",
      isMajorFeast: true,
    ),
    "Joseph": SaintModel(
      name: "புனித யோசேப்பு",
      bio: "திருக்குடும்பத்தின் பாதுகாவலர்.",
      prayer: "புனித யோசேப்பே, எங்கள் குடும்பங்களை பாதுகாத்தருளும்.",
      isMajorFeast: true,
    ),
    "George": SaintModel(
      name: "புனித ஜார்ஜ்",
      bio: "வீரமறைசாட்சி. தீமையை எதிர்த்துப் போராட வலிமை அளிப்பவர்.",
      prayer: "இறைவா, தீமையை வெல்லும் துணிவை தாரும்.",
      isMajorFeast: true,
    ),
    "Anthony": SaintModel(
      name: "புனித அந்தோனியார்",
      bio: "புதுமை வரரும் போதகருமானவர். தொலைந்த பொருட்களின் பாதுகாவலர்.",
      prayer:
          "புனித அந்தோனியாரே, இறைவனை நோக்கிய வழியை நாங்கள் காண உதவியருளும்.",
      isMajorFeast: true,
    ),
    "Thomas": SaintModel(
      name: "புனித தோமையார்",
      bio:
          "இந்தியாவின் அப்போஸ்தலர். 'என் ஆண்டவரே, என் தேவனே' என்று முழங்கியவர்.",
      prayer: "ஆண்டவரே, எங்கள் நம்பிக்கையை வளர்த்தருளும்.",
      isMajorFeast: true,
    ),
    "MotherTeresa": SaintModel(
      name: "புனித அன்னை தெரசா",
      bio: "ஏழைகளிலும் ஏழைகளுக்கு சேவை செய்தவர்.",
      prayer: "இறைவா, ஏழைகளில் உம்மை காணும் வரம் தாரும்.",
      isMajorFeast: true,
    ),
    "Francis": SaintModel(
      name: "புனித பிரான்சிஸ் அசிசியார்",
      bio: "எளிமையின் வடிவம். இயற்கையை நேசித்தவர்.",
      prayer: "இறைவா, என்னை உமது அமைதியின் கருவியாக மாற்றியருளும்.",
      isMajorFeast: true,
    ),
    "Xavier": SaintModel(
      name: "புனித சவேரியார்",
      bio: "மிஷனரி பணிகளின் பாதுகாவலர்.",
      prayer:
          "இறைவா, உமது வார்த்தையைப் பரப்பும் வைராக்கியத்தை எமக்குத் தாரும்.",
      isMajorFeast: true,
    ),
    "Christmas": SaintModel(
      name: "கிறிஸ்து பிறப்பு",
      bio: "உலக மீட்பர் இயேசுவின் பிறப்பு விழா.",
      prayer: "உன்னதங்களிலே கடவுளுக்கு மகிமை உண்டாகுக.",
      isMajorFeast: true,
    ),
    "Immaculate": SaintModel(
      name: "அமல உற்பவம்",
      bio: "அன்னை மரியா ஜென்ம பாவமின்றி பிறந்த விழா.",
      prayer: "பாவமின்றி உற்பவித்த மரியே, எங்களுக்காக வேண்டிக்கொள்ளும்.",
      isMajorFeast: true,
    ),
  };

  // ==========================================================
  // 6. DAILY NAMES MAP (Hindi) - KEY DATES
  // ==========================================================
  static final Map<String, String> _dailyNamesHi = {
    "1-1": "इश्वर की माँ मरियम",
    "1-2": "संत बसील और ग्रेगोरी",
    "1-6": "प्रभु प्रकटीकरण",
    "1-17": "संत अन्तोनी वनवासी",
    "1-20": "संत सेबास्टियन",
    "1-21": "संत अगनेस",
    "1-24": "संत फ्रांसिस दे सेल्स",
    "1-28": "संत थॉमस एक्विनास",
    "1-31": "संत जॉन बास्को",
    "2-2": "प्रभु की भेंट",
    "2-5": "संत अगथा",
    "2-11": "लूर्द की हमारी मां",
    "2-14": "संत सिरिल और मेथोडियस",
    "3-17": "संत पैट्रिक",
    "3-19": "संत यूसुफ",
    "3-25": "प्रभु की घोषणा",
    "4-23": "संत जॉर्ज",
    "5-1": "संत यूसुफ कारिगर",
    "5-13": "फातिमा की हमारी मां",
    "6-13": "संत अन्तोनी आफ़ पदुआ",
    "6-24": "संत यूहन्ना बप्तिस्मता का जन्म",
    "6-29": "संत पेत्रुस और पूलुस",
    "7-3": "संत थॉमस अपोस्तल",
    "7-22": "संत मरियम मगदलीनी",
    "7-31": "संत इग्नेशियस",
    "8-4": "संत जॉन वियानी",
    "8-15": "मरियम का स्वर्गारोहण",
    "8-27": "संत मॉनिका",
    "8-28": "संत ऑगस्टीन",
    "9-5": "संत तेरेसा कलकत्ता",
    "9-8": "मरियम का जन्म",
    "9-29": "प्रमुख दूत",
    "10-1": "संत तेरेसा लिसिउख",
    "10-2": "रक्षक दूत",
    "10-4": "संत फ्रांसिस असीसी",
    "11-1": "सब संतों का पर्व",
    "11-2": "सब आत्माओं का दिन",
    "12-3": "संत फ्रांसिस क्षेवियर",
    "12-6": "संत निकोलस",
    "12-8": "मरियम की निष्कलंक उत्पत्ति",
    "12-12": "ग्वादालूपे की माता",
    "12-13": "संत लूसी",
    "12-25": "प्रभु येसु का जन्म",
    "12-26": "संत स्तेफनुस",
    "12-27": "संत यूहन्ना सुसमाचारक",
    "12-28": "पवित्र बालक",
    "12-24": "क्रिसमस पूर्वसंध्या",
  };

  // ==========================================================
  // 6.5 DAILY NAMES MAP (Malayalam) - KEY DATES
  // ==========================================================
  static final Map<String, String> _dailyNamesMl = {
    "1-1": "ദൈവമാതാവായ പരിശുദ്ധ മറിയം",
    "1-2": "വിശുദ്ധ ബേസിൽ, വിശുദ്ധ ഗ്രിഗറി",
    "1-6": "ദനഹാ തിരുനാൾ",
    "1-20": "വിശുദ്ധ സെബസ്ത്യാനോസ്",
    "1-21": "വിശുദ്ധ ആഗ്നസ്",
    "1-25": "വിശുദ്ധ പൗലോസ് ശ്ലീഹായുടെ മാനസാന്തരം",
    "1-31": "വിശുദ്ധ ജോൺ ബോസ്കോ",
    "2-2": "ഈശോയെ കാഴ്ചവെച്ച തിരുനാൾ",
    "2-11": "ലൂർദ് മാതാവ്",
    "3-19": "വിശുദ്ധ യൗസേപ്പിതാവ്",
    "3-25": "മംഗളവാർത്ത",
    "4-23": "വിശുദ്ധ ഗീവർഗീസ് സഹദാ",
    "5-1": "തൊഴിലാളിയായ വിശുദ്ധ യൗസേപ്പ്",
    "5-13": "ഫാത്തിമ മാതാവ്",
    "6-13": "അന്തോണീസ് പുണ്യാളൻ",
    "6-24": "സ്നാപക യോഹന്നാന്റെ ജനനം",
    "6-29": "വിശുദ്ധ പത്രോസ്, വിശുദ്ധ പൗലോസ്",
    "7-3": "വിശുദ്ധ തോമാശ്ലീഹാ",
    "7-22": "വിശുദ്ധ മഗ്ദലന മറിയം",
    "8-15": "പരിശുദ്ധ മാതാവിന്റെ സ്വർഗ്ഗാരോഹണം",
    "9-5": "വിശുദ്ധ മദർ തെരേസ",
    "9-8": "പരിശുദ്ധ മാതാവിന്റെ ജനനം",
    "9-15": "വ്യാകുല മാതാവ്",
    "10-1": "വിശുദ്ധ കൊച്ചുത്രേസ്യ",
    "10-2": "കാവൽ മാലാഖമാർ",
    "10-4": "വിശുദ്ധ ഫ്രാൻസിസ് അസീസി",
    "11-1": "സകല വിശുദ്ധരുടെയും തിരുനാൾ",
    "11-2": "സകല മരിച്ചവരുടെയും ഓർമ്മ",
    "12-3": "വിശുദ്ധ ഫ്രാൻസിസ് സേവ്യർ",
    "12-6": "വിശുദ്ധ നിക്കോളസ്",
    "12-8": "പരിശുദ്ധ മാതാവിന്റെ അമലോദ്ഭവം",
    "12-12": "വിശുദ്ധ യുവാൻ ഡിഗൊ",
    "12-13": "വിശുദ്ധ ലൂസിയ",
    "12-25": "ക്രിസ്മസ്",
    "12-26": "വിശുദ്ധ സ്തേഫാനോസ്",
    "12-28": "കുഞ്ഞിപ്പൈതങ്ങളുടെ തിരുനാൾ",
  };

  // ==========================================================
  // 7. MAJOR SAINTS DATA (Detailed Hindi)
  // ==========================================================
  static final Map<String, SaintModel> _majorSaintsHi = {
    "MaryMother": SaintModel(
      name: "इश्वर की माँ मरियम",
      bio: "येसु की माँ। नववर्ष के आरंभ में हम अन्ना की सुरक्षा में अपने आप को समर्पित करते हैं।",
      prayer: "हे मरियम, ईश्वर की माँ, हम पापियों के लिए प्रार्थना करो।",
      isMajorFeast: true,
    ),
    "Joseph": SaintModel(
      name: "संत यूसुयफ",
      bio: "पवित्र परिवार के रक्षक।",
      prayer: "संत यूसुयफ, हमारे परिवारों की रक्षा करो।",
      isMajorFeast: true,
    ),
    "George": SaintModel(
      name: "संत जॉर्ज",
      bio: "वीर शहीद। त्याग और साहस के प्रतीक।",
      prayer: "हे ईश्वर, हमें बुराई से लड़ने का साहस दाओ।",
      isMajorFeast: true,
    ),
    "Anthony": SaintModel(
      name: "संत अन्तोनी आफ़ पदुआ",
      bio: "महान उपदेशक और चमत्कारी। खोई चीजों के संरक्षक।",
      prayer: "संत अन्तोनी, ईश्वर तक हमारा मार्ग दिखाओ।",
      isMajorFeast: true,
    ),
    "Thomas": SaintModel(
      name: "संत थॉमस अपोस्तल",
      bio: "भारत के अपोस्तल। उन्होंने कहा: 'मेरे प्रभु और मेरे ईश्वर!'.",
      prayer: "हे प्रभु, हमारा विश्वास बढ़ाओ।",
      isMajorFeast: true,
    ),
    "MotherTeresa": SaintModel(
      name: "संत तेरेसा कलकत्ता",
      bio: "गरीबों की सेविका। सबसे गरीबों की सेवा की।",
      prayer: "हे ईश्वर, गरीबों में आपको देखने की कृपा दो।",
      isMajorFeast: true,
    ),
    "Francis": SaintModel(
      name: "संत फ्रांसिस असीसी",
      bio: "निर्धनता और प्रकृति के प्रेमी। फ्रांसिस्कन संघ के संस्थापक।",
      prayer: "हे प्रभु, मुझे अपनी शांति का यंत्र बनाओ।",
      isMajorFeast: true,
    ),
    "Xavier": SaintModel(
      name: "संत फ्रांसिस क्षेवियर",
      bio: "मिशनरी कार्य के संरक्षक। एशिया के महान सुसमाचारक।",
      prayer: "हे प्रभु, आत्माओं के लिए उत्साह दो।",
      isMajorFeast: true,
    ),
    "Christmas": SaintModel(
      name: "प्रभु का जन्म",
      bio: "वचन मांस बना और हमारे बीच बस गया।",
      prayer: "सर्वोच्च में ईश्वर की महिमा।",
      isMajorFeast: true,
    ),
    "Immaculate": SaintModel(
      name: "मरियम की निष्कलंक उत्पत्ति",
      bio: "मरियम मोंल पाप के बिना गर्भधारण किया गया।",
      prayer: "हे मरियम, पाप से रहित उत्पन्न हुई, हमारे लिए प्रार्थना करो।",
      isMajorFeast: true,
    ),
  };

  // ==========================================================
  // 8. MAJOR SAINTS DATA (Detailed Malayalam)
  // ==========================================================
  static final Map<String, SaintModel> _majorSaintsMl = {
    "MaryMother": SaintModel(
      name: "ദൈവമാതാവായ പരിശുദ്ധ മറിയം",
      bio: "ദൈവപുത്രന്റെ മാതാവായ മറിയത്തെ വർഷത്തിന്റെ ആദ്യദിനം നാം വണങ്ങുന്നു.",
      prayer: "പരിശുദ്ധ മറിയമേ തമ്പുരാന്റെ അമ്മേ, ഞങ്ങൾക്കായി അപേക്ഷിക്കണമേ.",
      isMajorFeast: true,
    ),
    "Joseph": SaintModel(
      name: "വിശുദ്ധ യൗസേപ്പിതാവ്",
      bio: "തിരുക്കുടുംബത്തിന്റെ പാലകനും നാഥനും.",
      prayer: "വിശുദ്ധ യൗസേപ്പിതാവേ, ഞങ്ങളുടെ കുടുംബങ്ങളെ കാത്തുകൊള്ളണമേ.",
      isMajorFeast: true,
    ),
    "Thomas": SaintModel(
      name: "വിശുദ്ധ തോമാശ്ലീഹാ",
      bio: "ഭാരതത്തിന്റെ അപ്പസ്തോലൻ. 'എന്റെ കർത്താവേ എന്റെ ദൈവമേ' എന്ന് മന്ത്രിച്ചവൻ.",
      prayer: "ആരാധനാപാത്രമായ കർത്താവേ, ഞങ്ങങ്ങളുടെ വിശ്വാസം വർദ്ധിപ്പിക്കേണമേ.",
      isMajorFeast: true,
    ),
    "Christmas": SaintModel(
      name: "ക്രിസ്മസ്",
      bio: "ലോകരക്ഷകനായ ഈശോമിശിഹായുടെ തിരുപ്പിറവി.",
      prayer: "അത്യുന്നതങ്ങളിൽ ദൈവത്തിന് സ്തുതി.",
      isMajorFeast: true,
    ),
  };
}
