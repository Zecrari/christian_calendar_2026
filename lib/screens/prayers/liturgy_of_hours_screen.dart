import 'package:flutter/material.dart';

class LiturgyOfHoursScreen extends StatefulWidget {
  final String lang;
  const LiturgyOfHoursScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<LiturgyOfHoursScreen> createState() => _LiturgyOfHoursScreenState();
}

class _LiturgyOfHoursScreenState extends State<LiturgyOfHoursScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _initialTab = 0;

  @override
  void initState() {
    super.initState();
    // Auto-select tab based on time of day
    final hour = DateTime.now().hour;
    if (hour < 9) {
      _initialTab = 0; // Morning
    } else if (hour < 13) {
      _initialTab = 1; // Midday
    } else if (hour < 18) {
      _initialTab = 2; // Evening
    } else {
      _initialTab = 3; // Night
    }
    _tabController = TabController(length: 4, vsync: this, initialIndex: _initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;

    Color headerColor;
    String timeLabel;
    IconData timeIcon;
    if (hour < 9) {
      headerColor = const Color(0xFFF57C00);
      timeLabel = 'Morning Prayer (Lauds)';
      timeIcon = Icons.wb_sunny_rounded;
    } else if (hour < 13) {
      headerColor = const Color(0xFFFFB300);
      timeLabel = 'Midday Prayer';
      timeIcon = Icons.wb_sunny;
    } else if (hour < 18) {
      headerColor = const Color(0xFF1565C0);
      timeLabel = 'Evening Prayer (Vespers)';
      timeIcon = Icons.nights_stay_outlined;
    } else {
      headerColor = const Color(0xFF1A237E);
      timeLabel = 'Night Prayer (Compline)';
      timeIcon = Icons.bedtime_rounded;
    }

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [headerColor, headerColor.withOpacity(0.6)],
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 4),
                Icon(timeIcon, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Liturgy of the Hours',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        timeLabel,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: headerColor,
            labelColor: headerColor,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: const [
              Tab(text: '🌅 Morning'),
              Tab(text: '☀️ Midday'),
              Tab(text: '🌇 Evening'),
              Tab(text: '🌙 Night'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMorningPrayer(theme),
                _buildMiddayPrayer(theme),
                _buildEveningPrayer(theme),
                _buildNightPrayer(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMorningPrayer(ThemeData theme) {
    return _buildPrayerPage(
      color: const Color(0xFFF57C00),
      icon: Icons.wb_sunny_rounded,
      title: 'Morning Prayer — Lauds',
      intro: 'Begin each morning by consecrating the day to God.',
      sections: [
        _PrayerSection(
          'Opening Verse',
          'O Lord, open my lips, and my mouth will proclaim Your praise.',
          icon: Icons.open_in_new_rounded,
          color: Colors.orange,
        ),
        _PrayerSection(
          'Morning Offering',
          'O Jesus, through the Immaculate Heart of Mary, I offer You my prayers, works, joys, and sufferings of this day for all the intentions of Your Sacred Heart, in union with the Holy Sacrifice of the Mass throughout the world, in reparation for my sins, for the intentions of all my relatives and friends, and in particular for the intentions of the Holy Father. Amen.',
          icon: Icons.favorite_rounded,
          color: Colors.red,
        ),
        _PrayerSection(
          'Psalm 63 – Morning Psalm',
          'O God, You are my God; earnestly I seek You;\n'
              'My soul thirsts for You; my body faints for You,\n'
              'as in a dry and weary land where there is no water.\n\n'
              'So I have looked upon You in the sanctuary,\n'
              'beholding Your power and glory.\n'
              'Because Your steadfast love is better than life,\n'
              'my lips will praise You.\n\n'
              'So I will bless You as long as I live;\n'
              'in Your name I will lift up my hands.\n'
              'My soul will be satisfied as with fat and rich food,\n'
              'and my mouth will praise You with joyful lips.\n\n'
              'Glory be to the Father, and to the Son,\n'
              'and to the Holy Spirit.\n'
              'As it was in the beginning, is now,\n'
              'and ever shall be, world without end. Amen.',
          icon: Icons.auto_stories_rounded,
          color: Colors.blue,
        ),
        _PrayerSection(
          'Morning Reflection',
          'Lord, as this new day begins, I acknowledge that all I have comes from You. My breath, my life, my gifts — all are Yours. Help me to use this day for Your glory. Let me see Christ in each person I meet. Help me to speak words of life, to act with kindness, and to remain conscious of Your presence throughout this day. Amen.',
          icon: Icons.wb_twilight_rounded,
          color: Colors.orange,
        ),
        _PrayerSection(
          'Morning Canticle (Benedictus – Luke 1:68-79)',
          'Blessed be the Lord, the God of Israel;\n'
              'He has come to His people and set them free.\n'
              'He has raised up for us a mighty saviour,\n'
              'born of the house of His servant David.\n\n'
              'Through His holy prophets He promised of old\n'
              'that He would save us from our enemies,\n'
              'from the hands of all who hate us.\n\n'
              'He promised to show mercy to our fathers\n'
              'and to remember His holy covenant.\n'
              'This was the oath He swore to our father Abraham:\n'
              'to set us free from the hands of our enemies,\n'
              'free to worship Him without fear,\n'
              'holy and righteous in His sight all the days of our life.\n\n'
              'You, my child, shall be called the prophet of the Most High;\n'
              'for you will go before the Lord to prepare His way.\n'
              'To give His people knowledge of salvation\n'
              'by the forgiveness of their sins.\n\n'
              'In the tender compassion of our God\n'
              'the dawn from on high shall break upon us,\n'
              'to shine on those who dwell in darkness\n'
              'and the shadow of death,\n'
              'and to guide our feet into the way of peace.',
          icon: Icons.star_rounded,
          color: Colors.amber,
        ),
        _PrayerSection(
          'Closing Prayer',
          'Lord God, almighty Father, You have brought us safely to the beginning of this day. Help us to live it to the full in Your service. May every thought, word, and action praise You. Through Christ our Lord. Amen.',
          icon: Icons.check_circle_rounded,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildMiddayPrayer(ThemeData theme) {
    return _buildPrayerPage(
      color: const Color(0xFFFFB300),
      icon: Icons.wb_sunny,
      title: 'Midday Prayer (Terce/Sext/None)',
      intro: 'A brief pause at noon to reconnect with God.',
      sections: [
        _PrayerSection(
          'Opening',
          'O God, come to my assistance.\nO Lord, make haste to help me.\nGlory be to the Father, and to the Son, and to the Holy Spirit. As it was in the beginning, is now, and ever shall be, world without end. Amen.',
          icon: Icons.record_voice_over_rounded,
          color: Colors.amber,
        ),
        _PrayerSection(
          'Midday Psalm (Psalm 23)',
          'The Lord is my shepherd; I shall not want.\n'
              'He makes me lie down in green pastures.\n'
              'He leads me beside still waters.\n'
              'He restores my soul.\n\n'
              'He leads me in paths of righteousness\n'
              'for His name\'s sake.\n\n'
              'Even though I walk through the valley\n'
              'of the shadow of death,\n'
              'I will fear no evil,\n'
              'for You are with me;\n'
              'Your rod and Your staff, they comfort me.\n\n'
              'You prepare a table before me\n'
              'in the presence of my enemies.\n'
              'You anoint my head with oil;\n'
              'my cup overflows.\n\n'
              'Surely goodness and mercy shall follow me\n'
              'all the days of my life,\n'
              'and I shall dwell in the house of the Lord forever.',
          icon: Icons.auto_stories_rounded,
          color: Colors.blue,
        ),
        _PrayerSection(
          'Angelus (Noon Prayer)',
          'The Angel of the Lord declared to Mary:\n'
              'And she conceived of the Holy Spirit.\n'
              'Hail Mary, full of grace...\n\n'
              '"Behold the handmaid of the Lord:\n'
              'Be it done unto me according to Thy word."\n'
              'Hail Mary, full of grace...\n\n'
              'And the Word was made Flesh:\n'
              'And dwelt among us.\n'
              'Hail Mary, full of grace...\n\n'
              'Pray for us, O Holy Mother of God,\n'
              'That we may be made worthy of the promises of Christ.\n\n'
              'Lord, fill our hearts with Your grace:\n'
              'that we who have known the incarnation of Christ, Your Son, revealed by the message of an angel, may by His Passion and Cross be brought to the glory of His Resurrection. Through Christ our Lord. Amen.',
          icon: Icons.star_rounded,
          color: Colors.purple,
        ),
        _PrayerSection(
          'Midday Intercessions',
          'Lord, hear our midday prayers.\nFor those who are suffering right now — comfort them.\nFor those who are working — give them diligence.\nFor those who are lost — show them the way.\nFor those we love — protect and bless them.\nFor peace in the world — O Lord, hear us.\nAmen.',
          icon: Icons.record_voice_over_rounded,
          color: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildEveningPrayer(ThemeData theme) {
    return _buildPrayerPage(
      color: const Color(0xFF1565C0),
      icon: Icons.nights_stay_outlined,
      title: 'Evening Prayer — Vespers',
      intro: 'Close the day by giving thanks and seeking peace.',
      sections: [
        _PrayerSection(
          'Opening',
          'O God, come to my assistance.\nO Lord, make haste to help me.\nGlory be to the Father, and to the Son, and to the Holy Spirit. As it was in the beginning, is now, and ever shall be, world without end. Amen.',
          icon: Icons.record_voice_over_rounded,
          color: Colors.blue,
        ),
        _PrayerSection(
          'Evening Psalm (Psalm 141)',
          'I call to You, Lord; come quickly to me;\n'
              'hear me when I call to You.\n'
              'May my prayer be set before You like incense;\n'
              'may the lifting up of my hands\n'
              'be like the evening sacrifice.\n\n'
              'Set a guard over my mouth, Lord;\n'
              'keep watch over the door of my lips.\n'
              'Do not let my heart be drawn to what is evil\n'
              'so that I take part in wicked deeds\n'
              'with those who are evildoers.',
          icon: Icons.auto_stories_rounded,
          color: Colors.indigo,
        ),
        _PrayerSection(
          'Evening Canticle (Magnificat – Luke 1:46-55)',
          'My soul glorifies the Lord,\n'
              'and my spirit rejoices in God my Saviour,\n'
              'for He has been mindful\n'
              'of the humble state of His servant.\n\n'
              'From now on all generations will call me blessed,\n'
              'for the Mighty One has done great things for me—\n'
              'holy is His name.\n'
              'His mercy extends to those who fear Him,\n'
              'from generation to generation.\n\n'
              'He has performed mighty deeds with His arm;\n'
              'He has scattered those who are proud in their inmost thoughts.\n'
              'He has brought down rulers from their thrones\n'
              'but has lifted up the humble.\n'
              'He has filled the hungry with good things\n'
              'but has sent the rich away empty.\n\n'
              'He has helped His servant Israel,\n'
              'remembering to be merciful\n'
              'to Abraham and his descendants forever,\n'
              'just as He promised our ancestors.',
          icon: Icons.star_rounded,
          color: Colors.amber,
        ),
        _PrayerSection(
          'Evening Intercessions',
          'Lord, as the day draws to a close we bring before You:\n\n'
              'Those who laboured today without recognition — see them, Lord.\n'
              'Those who failed today — grant them hope for tomorrow.\n'
              'Those who are lonely tonight — be their companion.\n'
              'Those who are dying — receive them into Your mercy.\n'
              'Those we love — bless and protect them through the night.\n\n'
              'We pray for peace in every troubled home and land.\n'
              'Amen.',
          icon: Icons.volunteer_activism_rounded,
          color: Colors.purple,
        ),
        _PrayerSection(
          'Evening Closing',
          'Lord, watch over us this night. Let no harm come to those we love. Preserve us in body and soul. May we rise tomorrow to praise You anew. Through Christ our Lord. Amen.',
          icon: Icons.bedtime_rounded,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildNightPrayer(ThemeData theme) {
    return _buildPrayerPage(
      color: const Color(0xFF1A237E),
      icon: Icons.bedtime_rounded,
      title: 'Night Prayer — Compline',
      intro: 'The last prayer of the day, placing yourself in God\'s hands.',
      sections: [
        _PrayerSection(
          'Examination of Conscience',
          'Spend a moment in silence. Ask:\n'
              '• Did I thank God today?\n'
              '• Did I love my neighbour well?\n'
              '• Did I speak truth with charity?\n'
              '• Did I seek God in my daily work?\n'
              '• Is there anyone I need to forgive?\n\n'
              'For any failures, simply say: "Lord, have mercy."',
          icon: Icons.self_improvement_rounded,
          color: Colors.indigo,
        ),
        _PrayerSection(
          'Night Psalm (Psalm 91)',
          'Whoever dwells in the shelter of the Most High\n'
              'will rest in the shadow of the Almighty.\n'
              'I will say of the Lord, "He is my refuge and my fortress,\n'
              'my God, in whom I trust."\n\n'
              'He will cover you with His feathers,\n'
              'and under His wings you will find refuge;\n'
              'His faithfulness will be your shield and rampart.\n\n'
              'You will not fear the terror of night,\n'
              'nor the arrow that flies by day...\n\n'
              '"Because he loves Me," says the Lord, "I will rescue him;\n'
              'I will protect him, for he acknowledges My name.\n'
              'He will call on Me, and I will answer him;\n'
              'I will be with him in trouble,\n'
              'I will deliver him and honor him."',
          icon: Icons.auto_stories_rounded,
          color: Colors.blue,
        ),
        _PrayerSection(
          'Night Canticle (Nunc Dimittis – Luke 2:29-32)',
          'Lord, now let Your servant go in peace;\n'
              'Your word has been fulfilled:\n'
              'my own eyes have seen the salvation\n'
              'which You have prepared in the sight of every people:\n'
              'a light to reveal You to the nations\n'
              'and the glory of Your people Israel.',
          icon: Icons.star_rounded,
          color: Colors.amber,
        ),
        _PrayerSection(
          'Hail, Holy Queen',
          'Hail, Holy Queen, Mother of Mercy!\n'
              'Our life, our sweetness, and our hope!\n'
              'To thee do we cry, poor banished children of Eve;\n'
              'to thee do we send up our sighs,\n'
              'mourning and weeping in this valley of tears.\n\n'
              'Turn then, most gracious advocate, thine eyes of mercy toward us;\n'
              'and after this our exile, show unto us the blessed fruit of thy womb, Jesus.\n\n'
              'O clement, O loving, O sweet Virgin Mary!\n'
              'Pray for us, O Holy Mother of God,\n'
              'That we may be made worthy of the promises of Christ.',
          icon: Icons.star_rounded,
          color: Colors.purple,
        ),
        _PrayerSection(
          'Night Blessing',
          'May the Lord Almighty grant us a quiet night and a perfect end. Amen.\n\n'
              'Into Your hands, Lord, I commend my spirit.\n'
              'You have redeemed me, Lord God of truth.\n\n'
              'Protect us, Lord, as we stay awake;\n'
              'watch over us as we sleep,\n'
              'that awake, we may keep watch with Christ,\n'
              'and asleep, rest in His peace. Amen.',
          icon: Icons.bedtime_rounded,
          color: Colors.indigo,
        ),
      ],
    );
  }

  Widget _buildPrayerPage({
    required Color color,
    required IconData icon,
    required String title,
    required String intro,
    required List<_PrayerSection> sections,
  }) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        // Header Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        )),
                    const SizedBox(height: 4),
                    Text(intro,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...sections.map((s) => _buildSectionCard(s)).toList(),
      ],
    );
  }

  Widget _buildSectionCard(_PrayerSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: section.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(section.icon, color: section.color, size: 20),
          ),
          title: Text(
            section.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          initiallyExpanded: section.title.contains('Opening') ||
              section.title.contains('Morning Offering') ||
              section.title.contains('Examination'),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                section.text,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.7,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerSection {
  final String title;
  final String text;
  final IconData icon;
  final Color color;

  const _PrayerSection(this.title, this.text, {required this.icon, required this.color});
}
