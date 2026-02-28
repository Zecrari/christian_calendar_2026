import 'package:flutter/material.dart';

class NovenaData {
  static List<Map<String, dynamic>> getNovenas(String lang) {
    if (lang == 'ta') return _novenasTa;
    if (lang == 'hi') return _novenasHi;
    if (lang == 'ml') return _novenasMl;
    return _novenasEn;
  }

  static final List<Map<String, dynamic>> _novenasEn = [
    {
      'title': 'Sacred Heart of Jesus',
      'color': const Color(0xFFD32F2F),
      'icon': Icons.favorite_rounded,
      'intro': 'O Lord Jesus Christ, to Your most Sacred Heart I confide this intention. Only look upon me, then do what Your Heart inspires. Let Your Sacred Heart decide. I count on it. I trust in it. I throw myself on Your mercy. Lord Jesus, You will not fail me.',
      'prayers': [
        {'day': 1, 'title': 'Day of Trust', 'prayer': 'O Sacred Heart of Jesus, I place all my trust in You. You are my strength, my refuge, and my consolation. Help me to begin this novena with a pure and loving heart, trusting that You hear every prayer. Sacred Heart of Jesus, I trust in You.'},
        {'day': 2, 'title': 'Day of Faith', 'prayer': 'Lord Jesus, increase my faith. Let me see with the eyes of the heart that Your love for me is boundless. I believe in Your mercy, in Your goodness, and in Your power to answer this prayer. Sacred Heart of Jesus, I trust in You.'},
        {'day': 3, 'title': 'Day of Hope', 'prayer': 'O Sacred Heart, You are the source of all hope. When all seems lost, You raise the fallen. When I am weak, You are strong. Fill me with the hope that does not disappoint. Sacred Heart of Jesus, I trust in You.'},
        {'day': 4, 'title': 'Day of Love', 'prayer': 'Dearest Jesus, let me love as You love — freely, fully, and without condition. May the fire of Your Sacred Heart ignite a flame of love in my heart for God and neighbor. Sacred Heart of Jesus, I trust in You.'},
        {'day': 5, 'title': 'Day of Surrender', 'prayer': 'Lord, I surrender all to You — my worries, my burdens, my desires. Into Your Sacred Heart I place them. Do with them as Your wisdom sees fit. I ask not my will but Yours be done. Sacred Heart of Jesus, I trust in You.'},
        {'day': 6, 'title': 'Day of Mercy', 'prayer': 'Merciful Jesus, I come before You today acknowledging my faults. Your Heart, pierced for our sins, is the fountain of mercy. Wash me clean, heal me, and forgive what I have done wrong. Sacred Heart of Jesus, I trust in You.'},
        {'day': 7, 'title': 'Day of Perseverance', 'prayer': 'Lord Jesus, grant me the grace to persevere in prayer and in virtue. Do not let me grow weary or discouraged. Let me press on, knowing that You reward those who seek You diligently. Sacred Heart of Jesus, I trust in You.'},
        {'day': 8, 'title': 'Day of Gratitude', 'prayer': 'Grateful Heart of Jesus, teach me gratitude. For every grace and blessing, seen and unseen, I give thanks. Help me to see Your hand at work in every circumstance of my life. Sacred Heart of Jesus, I trust in You.'},
        {'day': 9, 'title': 'Day of Offering', 'prayer': 'On this final day, O Sacred Heart, I offer this entire novena to You. Whatever answer You see fit to give, I accept it with love. United with Mary, I place this intention in Your hands. Sacred Heart of Jesus, I trust in You — forever and always. Amen.'},
      ],
    },
    {
      'title': 'Divine Mercy',
      'color': const Color(0xFF1565C0),
      'icon': Icons.water_drop_rounded,
      'intro': 'This novena was given by Jesus to St. Faustina. Each day a different group of souls is entrusted to Christ\'s mercy. Before each prayer, recite the Our Father, Hail Mary, and Apostles\' Creed.',
      'prayers': [
        {'day': 1, 'title': 'All Mankind', 'prayer': 'Most Merciful Jesus, whose very nature it is to have compassion on us and to forgive us, do not look upon our sins but upon our trust and confidence which we place in Your infinite goodness...'},
        {'day': 2, 'title': 'Souls of Priests and Clergy', 'prayer': 'Most Merciful Jesus, from whom comes all that is good, increase Your grace in us, men of the clergy, that we may perform worthy works of mercy...'},
        {'day': 3, 'title': 'Devout and Faithful Souls', 'prayer': 'Most Merciful Jesus, from the treasury of Your mercy, You impart Your graces in great abundance to each and all...'},
        {'day': 4, 'title': 'Pagans and Those Who Do Not Know God', 'prayer': 'Most Compassionate Jesus, You are the Light of the whole world. Receive into the abode of Your Most Compassionate Heart the souls of those who do not know God...'},
        {'day': 5, 'title': 'Heretics and Schismatics', 'prayer': 'Most Merciful Jesus, Goodness Itself, You do not refuse light to those who seek it of You. Receive into the abode of Your Most Compassionate Heart...'},
        {'day': 6, 'title': 'Meek and Humble Souls', 'prayer': 'Most Merciful Jesus, You yourself have said, "Learn from Me for I am meek and humble of heart." Receive into the abode of Your Most Compassionate Heart all meek and humble souls...'},
        {'day': 7, 'title': 'Souls Who Venerate Divine Mercy', 'prayer': 'Most Merciful Jesus, whose Heart is Love Itself, receive into the abode of Your Most Compassionate Heart the souls of those who particularly extol and venerate the greatness of Your mercy...'},
        {'day': 8, 'title': 'Souls in Purgatory', 'prayer': 'Most Merciful Jesus, You Yourself have said that You desire mercy; so I bring into the abode of Your Most Compassionate Heart the souls in Purgatory...'},
        {'day': 9, 'title': 'Lukewarm Souls', 'prayer': 'Most compassionate Jesus, You are Compassion Itself. I bring lukewarm souls into the abode of Your Most Compassionate Heart...'},
      ],
    },
    {
      'title': 'Holy Spirit',
      'color': const Color(0xFFF57C00),
      'icon': Icons.local_fire_department_rounded,
      'intro': 'This traditional novena to the Holy Spirit is prayed for nine days before Pentecost Sunday, though it may be prayed at any time to invoke the gifts and fruits of the Holy Spirit.',
      'prayers': [
        {'day': 1, 'title': 'Gift of Wisdom', 'prayer': 'Come, Holy Spirit, Spirit of Wisdom! Illumine the minds of those who make decisions...'},
        {'day': 2, 'title': 'Gift of Understanding', 'prayer': 'Come, Holy Spirit, Spirit of Understanding! Help us to know the mysteries of faith more deeply...'},
        {'day': 3, 'title': 'Gift of Counsel', 'prayer': 'Come, Holy Spirit, Spirit of Counsel! Direct us in all our ways...'},
        {'day': 4, 'title': 'Gift of Fortitude', 'prayer': 'Come, Holy Spirit, Spirit of Fortitude! Strengthen us in times of trial...'},
        {'day': 5, 'title': 'Gift of Knowledge', 'prayer': 'Come, Holy Spirit, Spirit of Knowledge! Grant us a true understanding of creation...'},
        {'day': 6, 'title': 'Gift of Piety', 'prayer': 'Come, Holy Spirit, Spirit of Piety! Fill our hearts with deep devotion and love for God...'},
        {'day': 7, 'title': 'Gift of Fear of the Lord', 'prayer': 'Come, Holy Spirit, Spirit of Holy Fear! Grant us a holy reverence for God...'},
        {'day': 8, 'title': 'Fruits of the Spirit', 'prayer': 'Come, Holy Spirit! Fill us with Your fruits: love, joy, peace, patience, kindness...'},
        {'day': 9, 'title': 'Come, Holy Spirit!', 'prayer': 'Come, Holy Spirit, fill the hearts of Your faithful and kindle in them the fire of Your love...'},
      ],
    },
    {
      'title': 'Our Lady of Guadalupe',
      'color': const Color(0xFF388E3C),
      'icon': Icons.star_rounded,
      'intro': 'This novena honours Our Lady of Guadalupe who appeared to St. Juan Diego in 1531. She is the Patroness of the Americas and a powerful intercessor.',
      'prayers': [
        for (int i = 1; i <= 9; i++)
          {
            'day': i,
            'title': 'Day $i',
            'prayer': 'Our Lady of Guadalupe, mystical rose, intercede for Holy Mother Church on behalf of all your children. Protect us from the evil one. Pray for us that we may stand firm in truth and faith. Teach us to love as your Son has loved us. On this day $i of our novena, we come to you with confidence, knowing that you present our petitions to your Son Jesus Christ. Mother of Mercy, hear our prayer. Amen.',
          },
      ],
    },
  ];

  static final List<Map<String, dynamic>> _novenasTa = [
    {
      'title': 'இயேசுவின் திரு இதயம்',
      'color': const Color(0xFFD32F2F),
      'icon': Icons.favorite_rounded,
      'intro': 'ஆண்டவராகிய இயேசு கிறிஸ்துவே, உமது திரு இதயத்திற்கு இந்த விண்ணப்பத்தை நான் நம்பிக்கையுடன் விடுகிறேன். என்னை மட்டும் பார்த்து, பின் உமது இதயம் என்ன வழிகாட்டுகிறதோ அதைச் செய்தருளும். உமது திரு இதயம் எதையும் தீர்மானிக்கட்டும்.',
      'prayers': [
        {'day': 1, 'title': 'நம்பிக்கையின் நாள்', 'prayer': 'இயேசுவின் திரு இருதயமே, என்னுடைய முழு நம்பிக்கையையும் உம் மீது வைக்கிறேன். நீரே என் பலம், என் தஞ்சம்.'},
        {'day': 2, 'title': 'விசுவாசத்தின் நாள்', 'prayer': 'இயேசுவே, என் விசுவாசத்தை அதிகரியும். என் மீதான உமது அன்பு எல்லையற்றது என்பதை நான் உணரச் செய்யும்.'},
        {'day': 3, 'title': 'எதிர்நோக்கின் நாள்', 'prayer': 'திரு இருதயமே, எல்லா எதிர்நோக்கின் ஊற்று நீரே. எல்லாம் இழந்ததாகத் தோன்றும்போது, தயவாய் என்னை உயர்த்தும்.'},
        {'day': 4, 'title': 'அன்பின் நாள்', 'prayer': 'என் அன்பு இயேசுவே, நீ நேசிப்பது போல் எந்த நிபந்தனையும் இல்லாமல் நான் நேசிக்க எனக்கு வழிகாட்டும்.'},
        {'day': 5, 'title': 'அர்ப்பணிப்பின் நாள்', 'prayer': 'ஆண்டவரே, என் கவலைகள், என் சுமைகள் அனைத்தையும் உம்மிடம் ஒப்புக்கொடுக்கிறேன். உமது திரு இருதயத்தில் அவற்றை வைக்கிறேன்.'},
        {'day': 6, 'title': 'இரக்கத்தின் நாள்', 'prayer': 'இரக்கமுள்ள இயேசுவே, என் தவறுகளை உணர்ந்து இன்று நான் உம்மிடம் வருகிறேன். என்னை மன்னித்தருளும்.'},
        {'day': 7, 'title': 'விடாமுயற்சியின் நாள்', 'prayer': 'இயேசுவே, ஜெபத்திலும் புண்ணியத்திலும் நான் விடாமுயற்சியுடன் இருக்க எனக்கு அருள்தாரும்.'},
        {'day': 8, 'title': 'நன்றியின் நாள்', 'prayer': 'கிருபையுள்ள இயேசுவின் இதயமே, நான் கண்ட மற்றும் காணாத ஒவ்வொரு ஆசீர்வாதத்திற்கும் உமக்கு நன்றி கூறுகிறேன்.'},
        {'day': 9, 'title': 'சமர்ப்பணத்தின் நாள்', 'prayer': 'இந்த இறுதி நாளில், ஓ திரு இருதயமே, இந்த நவநாளை முழுவதும் நான் உமக்கு அர்ப்பணிக்கிறேன். ஆமென்.'},
      ],
    },
    {
      'title': 'இயேசுவின் இறை இரக்கம்',
      'color': const Color(0xFF1565C0),
      'icon': Icons.water_drop_rounded,
      'intro': 'இந்த நவநாள் புனித பாஸ்டினா மூலம் இயேசுவால் வழங்கப்பட்டது. ஒவ்வொரு நாளும் பாவிகள் மீது இரக்கம் வேண்டி ஜெபிக்கிறோம்.',
      'prayers': [
        {'day': 1, 'title': 'அனைத்து மனிதர்களுக்காக', 'prayer': 'மிகவும் இரக்கமுள்ள இயேசுவே, எங்கள் பாவங்களின் மீது அல்லாமல், நாங்கள் வைக்கும் நம்பிக்கையின் பேரில் உமது எல்லையற்ற நன்மையைக் காட்டியருளும்...'},
        {'day': 2, 'title': 'குருக்களின் ஆண்மாக்களுக்காக', 'prayer': 'குருக்களின் ஆன்மாக்களுக்காக இறை இரக்கத்தை வேண்டுகிறோம்...'},
        {'day': 3, 'title': 'பக்தியுள்ள நம்பிக்கையான ஆன்மாக்களுக்காக', 'prayer': 'பக்தியுள்ள நம்பிக்கையான ஆன்மாக்களின் மீது இறங்கும்...'},
        {'day': 4, 'title': 'கடவுளை அறியாதவர்கள்', 'prayer': 'இயேசுவே, கடவுளை அறியாதவர்களின் ஆன்மாக்கள் மீது இரக்கம் காட்டும்...'},
        {'day': 5, 'title': 'திருச்சபையை விட்டுப் பிரிந்தவர்கள்', 'prayer': 'இறைவா, திருச்சபையை விட்டுப் பிரிந்தவர்களை வழிநடத்தும்...'},
        {'day': 6, 'title': 'சிறியவர்கள் மற்றும் எளியவர்கள்', 'prayer': 'குழந்தைகள் போன்ற தூய்மையான மனமுடைய ஆன்மாக்களின் மீது உமது கிருபை பொழிக...'},
        {'day': 7, 'title': 'உமது இரக்கத்தை மகிமைப்படுத்துபவர்கள்', 'prayer': 'உமது இரக்கத்தைப் போற்றும் ஆன்மாக்களுக்காக நாங்கள் இறைஞ்சுகிறோம்...'},
        {'day': 8, 'title': 'உத்தரிக்கும் ஸ்தலத்து ஆன்மாக்கள்', 'prayer': 'இரக்கமுள்ள இயேசுவே, உத்தரிக்கும் ஸ்தலத்து ஆன்மாக்களுக்கு நித்திய இளைப்பாற்றியை தாரும்...'},
        {'day': 9, 'title': 'மந்தமான ஆன்மாக்கள்', 'prayer': 'அன்பின் நெருப்பு அணைந்துபோன வெதுவெதுப்பான ஆன்மாக்கள் மீது இரக்கம் வையும்...'},
      ],
    },
    {
      'title': 'பரிசுத்த ஆவியின் நவநாள்',
      'color': const Color(0xFFF57C00),
      'icon': Icons.local_fire_department_rounded,
      'intro': 'ஆவியானவரின் வரங்களைப் பெற்றுக்கொள்ள வேண்டுகிறோம்.',
      'prayers': [
        {'day': 1, 'title': 'ஞானம்', 'prayer': 'பரிசுத்த ஆவியே, உம்முடைய ஞானத்தால் எங்களை ஒளியூட்டும்...'},
        {'day': 2, 'title': 'புரிந்துகொள்ளுதல்', 'prayer': 'பரிசுத்த ஆவியே, விசுவாசத்தின் இரகசியங்களை நாங்கள் புரிந்துகொள்ள உதவும்...'},
        {'day': 3, 'title': 'அறிவுரை', 'prayer': 'பரிசுத்த ஆவியே, எங்கள் முடிவுகளில் உமது அறிவுரையை தாரும்...'},
        {'day': 4, 'title': 'துணிவு', 'prayer': 'பரிசுத்த ஆவியே, துன்ப நேரங்களில் எங்களுக்குத் துணிவைத் தாரும்...'},
        {'day': 5, 'title': 'அறிவு', 'prayer': 'பரிசுத்த ஆவியே, படைப்பைப் பற்றிய உண்மையான அறிவை અમને வழங்கியருளும்...'},
        {'day': 6, 'title': 'பக்தி', 'prayer': 'பரிசுத்த ஆவியே, கடவுளிடம் ஆழமான பக்தியும் அன்பும் கொள்ளச் செய்யும்...'},
        {'day': 7, 'title': 'இறையச்சம்', 'prayer': 'பரிசுத்த ஆவியே, கடவுளுக்கு முன்பாகப் புனிதமான மரியாதை உணர்வை எங்களுக்குத் தாரும்...'},
        {'day': 8, 'title': 'ஆவியின் கனிகள்', 'prayer': 'பரிசுத்த ஆவியே! உமது அன்பால், மகிழ்ச்சியால், அமைதியால் எங்களை நிரப்பும்...'},
        {'day': 9, 'title': 'வருக, தூய ஆவியே!', 'prayer': 'வருக தூய ஆவியே, உமது அன்பின் நெருப்பால் எங்களை நிரப்பும்...'},
      ],
    },
    {
      'title': 'குவடலூப்பே அன்னை',
      'color': const Color(0xFF388E3C),
      'icon': Icons.star_rounded,
      'intro': 'குவடலூப்பே அன்னையின் நவநாள் மூலமாக நாம் அனைவரும் காக்கப்பட வேண்டுவோம்.',
      'prayers': [
        for (int i = 1; i <= 9; i++)
          {
            'day': i,
            'title': 'நாள் $i',
            'prayer': 'குவடலூப்பே அன்னையே, உமது பிள்ளைகள் அனைவருக்காகவும் தாய் திருச்சபைக்காகவும் பரிந்துபேசும். தீயோனிடமிருந்து எங்களைப் பாதுகாத்துக் கொள்ளும். நாம் சத்தியத்திலும் விசுவாசத்திலும் உறுதியாக நிற்க எங்களுக்காக செபியுங்கள். உமது மகன் எங்களை நேசித்தது போல நேசிக்க எங்களுக்குக் கற்றுக் கொடும். எங்கள் நவநாளின் இந்த $i-ம் நாளில் நம்பிக்கையோடு உன்னிடம் வருகிறோம். இரக்கத்தின் தாயே, எங்கள் மன்றாட்டைக் கேட்டருளும். ஆமென்.',
          },
      ],
    },
  ];

  static final List<Map<String, dynamic>> _novenasHi = [
    {
      'title': 'येसु का पवित्र हृदय',
      'color': const Color(0xFFD32F2F),
      'icon': Icons.favorite_rounded,
      'intro': 'हे प्रभु येसु मसीह, मैं अपनी इस प्रार्थना को आपके पवित्र हृदय में सौंपता हूँ। मेरी इस प्रार्थना का उत्तर केवल आप ही दे सकते हैं।',
      'prayers': [
        {'day': 1, 'title': 'विश्वास का दिन', 'prayer': 'हे प्रभु येसु के पवित्र हृदय, मैं अपना पूरा विश्वास तुम पर रखता हूँ। मेरी सहायता करें।'},
        {'day': 2, 'title': 'आशा का दिन', 'prayer': 'हे प्रभु येसु, मेरे विश्वास और आशा को मजबूत करें। मेरा आपसे गहरा रिश्ता बने।'},
        {'day': 3, 'title': 'प्रेम का दिन', 'prayer': 'हे पवित्र हृदय, आप ही मेरे जीवन में सारी आशा के स्रोत हैं। बिना शर्त प्रेम करना सिखाएं।'},
        {'day': 4, 'title': 'समर्पण का दिन', 'prayer': 'हे प्रभु, मैं आपके प्रेम को पूरी तरह से स्वीकार और दूसरों के साथ साझा करना चाहता हूँ। अपनी कृपा मुझ पर बरसाएं।'},
        {'day': 5, 'title': 'शांति का दिन', 'prayer': 'हे प्रभु, मैं अपनी चिंताओं, अपनी ज़िम्मेदारियों और अपने पापों को आपके सामने समर्पित करता हूँ।'},
        {'day': 6, 'title': 'दया का दिन', 'prayer': 'हे दयालु येसु, मैं आपके सामने आकर अपने सभी अपराधों की क्षमा माँगता हूँ। मुझे पवित्र करें।'},
        {'day': 7, 'title': 'दृढ़ता का दिन', 'prayer': 'हे प्रभु येसु, मुझे प्रार्थना में लगातार बने रहने का साहस और दृढ़ निश्चय दें।'},
        {'day': 8, 'title': 'कृतज्ञता का दिन', 'prayer': 'हे प्रभु, मेरे जीवन में आपके हर आशीर्वाद के लिए मैं आपको धन्यवाद अर्पित करता हूँ।'},
        {'day': 9, 'title': 'अर्पण का दिन', 'prayer': 'मैं अपनी पूरी नोवेना प्रार्थना आपको समर्पित करता हूँ। मेरी विनती को सुन लें, जैसा आपकी इच्छा हो। आमीन।'},
      ],
    },
    {
      'title': 'दिव्य दया (इश्वेरीय दया)',
      'color': const Color(0xFF1565C0),
      'icon': Icons.water_drop_rounded,
      'intro': 'दिव्य दया की नोवेना सन्त फ़ॉस्टिना को येसु के द्वारा दी गयी। इसे हर दिन अलग-अलग आत्माओं के लिए प्रार्थना में बोला जाता है।',
      'prayers': [
        {'day': 1, 'title': 'सम्पूर्ण मानवता के लिए', 'prayer': 'हे सबसे दयालु येसु, सम्पूर्ण मानवता पर अपनी दया बरसाएँ...'},
        {'day': 2, 'title': 'पुरोहितों और धार्मिक आत्माओं के लिए', 'prayer': 'हे प्रभु, सभी पुरोहितों और धार्मिक आत्माओं पर कृपा बरसाएँ...'},
        {'day': 3, 'title': 'भक्त और श्रद्धालु आत्माएं', 'prayer': 'हे सबसे दयालु प्रभु, भक्त और वफ़ादार आत्माओं को अपनी कृपा से भर दें...'},
        {'day': 4, 'title': 'वे जो ईश्वर को नहीं जानते', 'prayer': 'हे करुणा के स्वामी, उन पर दया करें जो अभी तक आपको नहीं जान पाए हैं...'},
        {'day': 5, 'title': 'जो कलीसिया से अलग हुए हैं', 'prayer': 'हे ईश्वर, जो मार्ग से भटक गए हैं उन्हें वापस अपने हृदय में ले आएं...'},
        {'day': 6, 'title': 'नम्र और विनम्र बच्चे', 'prayer': 'हे प्रभु, नम्र और विनम्र बच्चों और संतों की आत्माओं पर अपनी दया बरसाएँ...'},
        {'day': 7, 'title': 'ईश्वरीय दया का प्रचार करने वाले', 'prayer': 'वे आत्माएं जो आपकी दया का प्रचार करती हैं, उन्हें मजबूत और सुरक्षित रखें...'},
        {'day': 8, 'title': 'परगेटरी में आत्माएं', 'prayer': 'उन आत्माओं पर दया करें जो परगेटरी में हैं...'},
        {'day': 9, 'title': 'ठंडी और आलसी आत्माएं', 'prayer': 'हे प्रभु येसु, जो आत्माएं विश्वास में ठंडी पड़ गई हैं उन पर अपना प्रेम बरसाएँ...'},
      ],
    },
    {
      'title': 'पवित्र आत्मा की नोवेना',
      'color': const Color(0xFFF57C00),
      'icon': Icons.local_fire_department_rounded,
      'intro': 'पवित्र आत्मा से उनके उपहार और फलों की प्राप्ति के लिए प्रार्थना।',
      'prayers': [
        {'day': 1, 'title': 'प्रज्ञा', 'prayer': 'हे पवित्र आत्मा, हमें ज्ञान और प्रज्ञा (विज़्डम) प्रदान करें...'},
        {'day': 2, 'title': 'समझ', 'prayer': 'हे पवित्र आत्मा, विश्वास के रहस्यों को गहराई से समझने की कृपा दें...'},
        {'day': 3, 'title': 'सलाह', 'prayer': 'हे पवित्र आत्मा, हमारी मुश्किलों और निर्णयों में हमें सही सलाह प्रदान करें...'},
        {'day': 4, 'title': 'धैर्य और সাহস', 'prayer': 'हे पवित्र आत्मा, दुःख और परीक्षण के समय में हमें शक्ति और साहस दें...'},
        {'day': 5, 'title': 'ज्ञान', 'prayer': 'हे पवित्र आत्मा, हमें सच्चाई और ईश्वर की रचना का सही ज्ञान दें...'},
        {'day': 6, 'title': 'धर्मनिष्ठा', 'prayer': 'हे पवित्र आत्मा, हमारे हृदय को ईश्वर की भक्ति से भर दें...'},
        {'day': 7, 'title': 'ईश्वर का डर', 'prayer': 'हे पवित्र आत्मा, हमें पाप से दूर रखने और ईश्वर के प्रति सम्मान का भय दें...'},
        {'day': 8, 'title': 'आत्मा के फल', 'prayer': 'हे पवित्र आत्मा, हमारे जीवन में प्रेम, आनंद, शांति और दया को भर दें...'},
        {'day': 9, 'title': 'आओ, पवित्र आत्मा!', 'prayer': 'आओ हे पवित्र आत्मा, अपने विश्वासियों के दिलों को भरें और उन पर अपने प्रेम की आग प्रज्वलित करें...'},
      ],
    },
    {
      'title': 'मातर ग्वाडालुपे (Our Lady of Guadalupe)',
      'color': const Color(0xFF388E3C),
      'icon': Icons.star_rounded,
      'intro': 'ग्वाडालुपे की माता से दुनिया और कलीसिया की सुरक्षा के लिए प्रार्थना।',
      'prayers': [
        for (int i = 1; i <= 9; i++)
          {
            'day': i,
            'title': 'दिन $i',
            'prayer': 'हे ग्वाडालुपे की माता, अपने सभी बच्चों की ओर से हमारी पवित्र माँ कलीसिया के लिए प्रार्थना करें। दुष्टों की बुराई से हमें बचाएं। हमारे लिए प्रार्थना करें ताकि हम सत्य और विश्वास में दृढ़ रहें। हमें उस प्रकार प्रेम करना सिखाएं जिस प्रकार आपके पुत्र ने हमसे प्रेम किया है। अपनी इस $i दिन की नोवेना पर हम पूरे विश्वास के साथ आपके पास आते हैं। हे दया की माता, हमारी प्रार्थना सुनें। आमीन।',
          },
      ],
    },
  ];

  static final List<Map<String, dynamic>> _novenasMl = [
    {
      'title': 'ഈശോയുടെ തിരുഹൃദയം',
      'color': const Color(0xFFD32F2F),
      'icon': Icons.favorite_rounded,
      'intro': 'കർത്താവായ ഈശോമിശിഹായേ, അങ്ങയുടെ അതിപരിശുദ്ധ ഹൃദയത്തിൽ ഈ നിയോഗം ഞാൻ സമർപ്പിക്കുന്നു. എന്നെ കാരുണ്യത്തോടെ കടാക്ഷിക്കുകയും അങ്ങയുടെ തിരുമനസ്സുപോലെ പ്രവർത്തിക്കുകയും ചെയ്യണമേ.',
      'prayers': [
        {'day': 1, 'title': 'വിശ്വാസത്തിന്റെ ദിനം', 'prayer': 'ഈശോയുടെ തിരുഹൃദയമേ, എന്റെ പൂർണ്ണമായ ആശ്രയം അങ്ങയിലാകുന്നു. അങ്ങാണ് എന്റെ ബലവും സങ്കേതവും.'},
        {'day': 2, 'title': 'പ്രത്യാശയുടെ ദിനം', 'prayer': 'ഈശോയേ, എന്റെ വിശ്വാസം വർദ്ധിപ്പിക്കണമേ. അങ്ങയുടെ കാരുണ്യത്തിലും സ്‌നേഹത്തിലും ഞാൻ വിശ്വസിക്കുന്നു.'},
        {'day': 3, 'title': 'സ്‌നേഹത്തിന്റെ ദിനം', 'prayer': 'ഓ തിരുഹൃദയമേ, സകല പ്രതീക്ഷകളുടെയും ഉറവിടം അങ്ങാണ്. എനിക്ക് നിരുപാധികമായി സ്‌നേഹിക്കാൻ ദയവരുത്തണമേ.'},
        {'day': 4, 'title': 'സമർപ്പണത്തിന്റെ ദിനം', 'prayer': 'കർത്താവേ, ഞാൻ പൂർണ്ണമായി കൊതിക്കുന്നതും ചെയ്യുന്നതുമെല്ലാം അങ്ങേക്ക് സമർപ്പിക്കുന്നു.'},
        {'day': 5, 'title': 'സമാധാനത്തിന്റെ ദിനം', 'prayer': 'കർത്താവേ, എന്റെ ഉത്കണ്ഠകളും ഭാരങ്ങളും അങ്ങയുടെ തിരുമുമ്പിൽ ഞാൻ സമർപ്പിക്കുന്നു.'},
        {'day': 6, 'title': 'കരുണയുടെ ദിനം', 'prayer': 'കരുണാമയനായ ഈശോയേ, എന്റെ കുറവുകളെ ഓർത്ത് ഞാൻ ക്ഷമ ചോദിക്കുന്നു. എന്നെ ശുദ്ധീകരിക്കണമേ.'},
        {'day': 7, 'title': 'സ്ഥിരതയുടെ ദിനം', 'prayer': 'കർത്താവായ യേശുവേ, പ്രാർത്ഥനയിലും സുകൃതങ്ങളിലും സ്ഥിരതയോടെ നിലനിൽക്കുവാൻ എന്നെ അനുഗ്രഹിക്കണമേ.'},
        {'day': 8, 'title': 'കൃതജ്ഞതയുടെ ദിനം', 'prayer': 'ഈശോയുടെ തിരുഹൃദയമേ, അങ്ങ് നൽകിയതും നൽകുന്നതുമായ എല്ലാ അനുഗ്രഹങ്ങൾക്കും ഞാൻ നന്ദി പറയുന്നു.'},
        {'day': 9, 'title': 'അന്തിമ സമർപ്പണം', 'prayer': 'ഓ തിരുഹൃദയമേ, ഈ നൊവേന ഞാൻ അങ്ങേക്കു സമർപ്പിക്കുന്നു. അങ്ങയുടെ ഇഷ്ടംപോലെ എന്റെ പ്രാർത്ഥനകൾക്ക് ഉത്തരം നൽകണമേ. ആമ്മേൻ.'},
      ],
    },
    {
      'title': 'ദൈവകരുണ',
      'color': const Color(0xFF1565C0),
      'icon': Icons.water_drop_rounded,
      'intro': 'വിശുദ്ധ ഫൗസ്റ്റീനയ്ക്ക് നാഥൻ നൽകിയ ദൈവകരുണയുടെ നൊവേന. ഓരോ ദിവസവും പ്രകാശിപ്പിക്കപ്പെടുന്ന സന്ദേശങ്ങൾക്കനുസരിച്ച് പ്രാർത്ഥിക്കുക.',
      'prayers': [
        {'day': 1, 'title': 'മുഴുവൻ മനുഷ്യവർഗ്ഗത്തിനും വേണ്ടി', 'prayer': 'ഏറ്റവും കാരുണ്യവാനായ ഈശോയേ, ഞങ്ങളുടെ പാപങ്ങളെ നോക്കാതെ അങ്ങയുടെ അളവില്ലാത്ത കരുണയെ നോക്കി ഞങ്ങളെ അനുഗ്രഹിക്കണമേ...'},
        {'day': 2, 'title': 'വൈദികർക്കും സന്യസ്തർക്കും വേണ്ടി', 'prayer': 'ഏറ്റവും കാരുണ്യവാനായ ഈശോയേ, വൈദികർക്കും സന്യസ്തർക്കും അങ്ങയുടെ കൃപ വർദ്ധിപ്പിക്കണമേ...'},
        {'day': 3, 'title': 'വിശ്വസ്തരായ ആത്മാക്കൾക്ക് വേണ്ടി', 'prayer': 'ഏറ്റവും കാരുണ്യവാനായ ഈശോയേ, ഭക്തരും വിശ്വസ്തരുമായ ആത്മാക്കൾക്ക് അങ്ങയുടെ കരുണ ചൊരിയണമേ...'},
        {'day': 4, 'title': 'ദൈവത്തെ അറിയാത്തവർക്ക് വേണ്ടി', 'prayer': 'ഏറ്റവും കാരുണ്യവാനായ ഈശോയേ, ഈ ലോകത്തിന്റെ പ്രകാശമായ അങ്ങയെ ഇതുവരെ അറിയാത്ത എല്ലാവരെയും അനുഗ്രഹിക്കണമേ...'},
        {'day': 5, 'title': 'തിരുസഭയിൽ നിന്ന് അകന്നുപോയവർ', 'prayer': 'ഏറ്റവും കാരുണ്യവാനായ ഈശോയേ, സത്യമാർഗ്ഗം അന്വേഷിക്കുന്നവർക്ക് അങ്ങയുടെ പ്രകാശം നിഷേധിക്കരുതേ...'},
        {'day': 6, 'title': 'ശാന്തരും വിനയമുള്ളവരുമായ ആത്മാക്കൾ', 'prayer': 'ഏറ്റവും കാരുണ്യവാനായ ഈശോയേ, ശാന്തതയും വിനയവുമുള്ള സകല ആത്മാക്കളെയും അങ്ങയുടെ തിരുഹൃദയത്തിൽ സ്വീകരിക്കണമേ...'},
        {'day': 7, 'title': 'ദൈവകരുണയെ വണങ്ങുന്നവർ', 'prayer': 'ഏറ്റവും കാരുണ്യവാനായ ഈശോയേ, അങ്ങയുടെ കരുണയെ പ്രത്യേകം സ്തുതിക്കുകയും വണങ്ങുകയും ചെയ്യുന്ന എല്ലാവരെയും അനുഗ്രഹിക്കണമേ...'},
        {'day': 8, 'title': 'ശുദ്ധീകരണസ്ഥലത്തിലെ ആത്മാക്കൾ', 'prayer': 'ഏറ്റവും കാരുണ്യവാനായ ഈശോയേ, ശുദ്ധീകരണസ്ഥലത്തിൽ കഷ്ടപ്പെടുന്ന എല്ലാ ആത്മാക്കൾക്കും നിത്യവിശ്രമം നൽകണമേ...'},
        {'day': 9, 'title': 'തണുത്ത ആത്മാക്കൾക്ക് വേണ്ടി', 'prayer': 'ഏറ്റവും കാരുണ്യവാനായ ഈശോയേ, അങ്ങയുടെ സ്‌നേഹത്തിൽ ചൂടില്ലാതെ ജീവിക്കുന്ന തണുത്ത ആത്മാക്കളെ അങ്ങയുടെ കരുണയാൽ ജ്വലിപ്പിക്കണമേ...'},
      ],
    },
    {
      'title': 'പരിശുദ്ധാത്മാവിന്റെ നൊവേന',
      'color': const Color(0xFFF57C00),
      'icon': Icons.local_fire_department_rounded,
      'intro': 'പരിശുദ്ധാത്മാവിന്റെ ഏഴു ദാനങ്ങൾക്കും ഫലങ്ങൾക്കും വേണ്ടിയുള്ള നൊവേന.',
      'prayers': [
        {'day': 1, 'title': 'ജ്ഞാനം', 'prayer': 'പരിശുദ്ധാത്മാവേ എഴുന്നള്ളിവരണമേ, അങ്ങയുടെ ജ്ഞാനത്താൽ ഞങ്ങളുടെ മനസ്സുകളെ പ്രകാശിപ്പിക്കണമേ...'},
        {'day': 2, 'title': 'ബുദ്ധി', 'prayer': 'പരിശുദ്ധാത്മാവേ എഴുന്നള്ളിവരണമേ, വിശ്വാസത്തിന്റെ രഹസ്യങ്ങൾ പൂർണ്ണമായി മനസ്സിലാക്കാൻ ഞങ്ങളെ സഹായിക്കണമേ...'},
        {'day': 3, 'title': 'ആലോചന', 'prayer': 'പരിശുദ്ധാത്മാവേ എഴുന്നള്ളിവരണമേ, സകല കാര്യങ്ങളിലും ഞങ്ങളെ നേർവഴിക്ക് നയിക്കണമേ...'},
        {'day': 4, 'title': 'ധൈര്യം', 'prayer': 'പരിശുദ്ധാത്മാവേ എഴുന്നള്ളിവരണമേ, പ്രലോഭനങ്ങളിലും കഷ്ടപ്പാടുകളിലും ഞങ്ങൾക്ക് ധൈര്യം നൽകണമേ...'},
        {'day': 5, 'title': 'അറിവ്', 'prayer': 'പരിശുദ്ധാത്മാവേ എഴുന്നള്ളിവരണമേ, ലോകവസ്തുക്കളുടെ മായയിൽ നിന്ന് ഞങ്ങളെ അകറ്റി സത്യം മനസ്സിലാക്കാൻ കൃപ നൽകണമേ...'},
        {'day': 6, 'title': 'ഭക്തി', 'prayer': 'പരിശുദ്ധാത്മാവേ എഴുന്നള്ളിവരണമേ, ഞങ്ങളുടെ ഹൃദയങ്ങളിൽ ദൈവകരുണയോടുള്ള സ്നേഹം നിറയ്ക്കണമേ...'},
        {'day': 7, 'title': 'ദൈവഭയം', 'prayer': 'പരിശുദ്ധാത്മാവേ എഴുന്നള്ളിവരണമേ, അങ്ങേയ്ക്ക് അനിഷ്ടമായ സകലതും ഉപേക്ഷിക്കാൻ തക്കവിധം ദൈവഭയം ഞങ്ങൾക്ക് നൽകണമേ...'},
        {'day': 8, 'title': 'ആത്മാവിന്റെ ഫലങ്ങൾ', 'prayer': 'പരിശുദ്ധാത്മാവേ എഴുന്നള്ളിവരണമേ, സ്‌നേഹം, സന്തോഷം, സമാധാനം എന്നീ ഫലങ്ങളാൽ ഞങ്ങളെ നിറയ്ക്കണമേ...'},
        {'day': 9, 'title': 'വരിക പരിശുദ്ധാത്മാവേ!', 'prayer': 'പരിശുദ്ധാത്മാവേ എഴുന്നള്ളിവരണമേ, വിശ്വാസികളുടെ ഹൃദയങ്ങളിൽ അങ്ങയുടെ സ്‌നേഹാഗ്നി ജ്വലിപ്പിക്കണമേ...'},
      ],
    },
    {
      'title': 'ഗ്വാഡലൂപ്പേ മാതാവ്',
      'color': const Color(0xFF388E3C),
      'icon': Icons.star_rounded,
      'intro': 'വിശുദ്ധ ജുവാൻ ഡിയേഗോയ്ക്ക് പ്രത്യക്ഷപ്പെട്ട ഗ്വാഡലൂപ്പേ മാതാവിനോടുള്ള നൊവേന.',
      'prayers': [
        for (int i = 1; i <= 9; i++)
          {
            'day': i,
            'title': 'ദിനം $i',
            'prayer': 'ഗ്വാഡലൂപ്പേ മാതാവേ, അങ്ങയുടെ സകല മക്കൾക്കും തിരുസഭയ്ക്കും വേണ്ടി പ്രാർത്ഥിക്കണമേ. തിന്മയിൽ നിന്ന് ഞങ്ങളെ കാത്തുകൊള്ളണമേ. സത്യത്തിലും വിശ്വാസത്തിലും ഉറച്ചുനിൽക്കാൻ ഞങ്ങൾക്കുവേണ്ടി മാധ്യസ്ഥം വഹിക്കണമേ. ഈ നൊവേനയുടെ $i-ാം ദിവസമായ ഇന്ന് പൂർണ്ണവിശ്വാസത്തോടെ ഞങ്ങൾ അങ്ങയോട് പ്രാർത്ഥിക്കുന്നു. കാരുണ്യമാതാവേ, ഞങ്ങളുടെ അപേക്ഷകൾ കേൾക്കണമേ. ആമ്മേൻ.',
          },
      ],
    },
  ];
}
