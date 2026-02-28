import 'package:flutter/material.dart';
import '../../data/liturgical_calculator.dart';
import '../../data/saints_feast_data.dart';
import '../../data/storage_service.dart';
import '../../config/translations.dart';

class MoveableFeastsScreen extends StatefulWidget {
  final String lang;
  const MoveableFeastsScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<MoveableFeastsScreen> createState() => _MoveableFeastsScreenState();
}

class _MoveableFeastsScreenState extends State<MoveableFeastsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _baptismName = '';
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _baptismName = StorageService.getBaptismName();
    _nameController.text = _baptismName;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liturgical Feasts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF673AB7),
          labelColor: const Color(0xFF673AB7),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.church_rounded), text: 'Feasts'),
            Tab(icon: Icon(Icons.no_food_rounded), text: 'Fasting'),
            Tab(icon: Icon(Icons.person_rounded), text: 'My Saint'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeastsTab(theme),
          _buildFastingTab(theme),
          _buildMySaintTab(theme),
        ],
      ),
    );
  }

  // ─── TAB 1: Moveable Feasts ──────────────────────────────────────────────
  Widget _buildFeastsTab(ThemeData theme) {
    final year = DateTime.now().year;
    final today = DateTime.now();
    final feasts = LiturgicalCalculator.getMoveableFeasts(year);

    // Sort by date
    final entries = feasts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Easter countdown
    final daysUntilEaster = LiturgicalCalculator.daysUntilEaster(year);
    final daysUntilLent = LiturgicalCalculator.daysUntilLent(year);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      children: [
        // Hero Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFA000), Color(0xFFFF6F00)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.celebration_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Moveable Feasts $year',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'These holy days are calculated each year based on Easter Sunday.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _countdownBadge(
                    daysUntilEaster < 0
                        ? 'Easter was ${-daysUntilEaster}d ago'
                        : daysUntilEaster == 0
                            ? '🎉 Easter Today!'
                            : '$daysUntilEaster days to Easter',
                    Icons.egg_alt_rounded,
                  ),
                  const SizedBox(width: 10),
                  _countdownBadge(
                    daysUntilLent < 0
                        ? 'Lent began ${-daysUntilLent}d ago'
                        : daysUntilLent == 0
                            ? '🕯 Ash Wednesday Today'
                            : '$daysUntilLent days to Lent',
                    Icons.local_fire_department_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Feast List
        ...entries.map((e) {
          final date = e.key;
          final feastName = e.value;
          final isPast = date.isBefore(DateTime(today.year, today.month, today.day));
          final isToday = date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
          return _buildFeastCard(date, feastName, isPast, isToday, theme);
        }).toList(),
      ],
    );
  }

  Widget _countdownBadge(String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeastCard(
      DateTime date, String name, bool isPast, bool isToday, ThemeData theme) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    Color cardColor;
    if (isToday) {
      cardColor = const Color(0xFFFFA000);
    } else if (name.contains('Easter') || name.contains('Ascension') || name.contains('Trinity') || name.contains('Corpus')) {
      cardColor = const Color(0xFFFFD700);
    } else if (name.contains('Ash') || name.contains('Palm') || name.contains('Maundy') || name.contains('Good') || name.contains('Advent')) {
      cardColor = const Color(0xFF673AB7);
    } else if (name.contains('Pentecost')) {
      cardColor = Colors.red;
    } else {
      cardColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: isPast ? Colors.grey.shade400 : cardColor,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: (isPast ? Colors.grey : cardColor).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: isPast ? Colors.grey : cardColor,
                  ),
                ),
                Text(
                  months[date.month - 1],
                  style: TextStyle(
                    fontSize: 12,
                    color: isPast ? Colors.grey : cardColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isToday)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('TODAY 🎉',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isPast ? Colors.grey : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isPast
                      ? 'Passed'
                      : '${date.difference(DateTime.now()).inDays + 1} days away',
                  style: TextStyle(
                    color: isPast ? Colors.grey.shade400 : cardColor.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (!isPast)
            Icon(Icons.chevron_right_rounded,
                color: cardColor.withOpacity(0.5)),
        ],
      ),
    );
  }

  // ─── TAB 2: Fasting Days ─────────────────────────────────────────────────
  Widget _buildFastingTab(ThemeData theme) {
    final today = DateTime.now();
    final isFastingToday = LiturgicalCalculator.isFastingDay(today);
    final fastingLabel = LiturgicalCalculator.getFastingLabel(today, widget.lang);

    // Build next 30 days
    final upcomingFasts = <DateTime>[];
    for (int i = 1; i <= 60; i++) {
      final date = today.add(Duration(days: i));
      if (LiturgicalCalculator.isFastingDay(date)) {
        upcomingFasts.add(date);
        if (upcomingFasts.length >= 8) break;
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      children: [
        // Today Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: isFastingToday
                ? const LinearGradient(
                    colors: [Color(0xFF673AB7), Color(0xFF512DA8)])
                : LinearGradient(
                    colors: [
                      Colors.green.shade600,
                      Colors.green.shade800
                    ],
                  ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (isFastingToday ? Colors.deepPurple : Colors.green)
                    .withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFastingToday ? Icons.no_food_rounded : Icons.restaurant_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Today',
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                      Text(
                        isFastingToday ? 'Day of Fasting ✝' : 'No Fast Today',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isFastingToday) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    fastingLabel,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Fasting Guidelines
        _infoCard(
          title: '🐟 Catholic Fasting Guidelines',
          content:
              '• Fridays: Abstain from meat (year-round)\n'
              '• Ash Wednesday: Fast & complete abstinence\n'
              '• Good Friday: Strict fast & abstinence\n'
              '• Fasting = one full meal + two smaller meals that together don\'t equal one full meal\n'
              '• Ages 18-59 are bound to fast; 14+ abstain from meat',
          color: const Color(0xFF673AB7),
          theme: theme,
        ),
        const SizedBox(height: 12),

        // Upcoming fasting days
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10, top: 4),
          child: Text('UPCOMING FAST DAYS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 11,
                color: Color(0xFF673AB7),
              )),
        ),
        ...upcomingFasts.map((date) {
          final label = LiturgicalCalculator.getFastingLabel(date, widget.lang);
          final daysAway = date.difference(today).inDays;
          return _fastDayCard(date, label, daysAway, theme);
        }).toList(),
      ],
    );
  }

  Widget _fastDayCard(
      DateTime date, String label, int daysAway, ThemeData theme) {
    const color = Color(0xFF673AB7);
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final weekdays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: const BorderSide(color: color, width: 3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(weekdays[date.weekday - 1],
                  style: const TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 13)),
              Text('${date.day} ${months[date.month - 1]}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              daysAway == 1 ? 'Tomorrow' : 'In $daysAway days',
              style: const TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ─── TAB 3: My Saint / Personal Feast Day ───────────────────────────────
  Widget _buildMySaintTab(ThemeData theme) {
    final saint = SaintFeastData.findSaintByName(_baptismName);
    final isToday = saint != null && SaintFeastData.isFeastDayToday(saint);
    final upcoming = saint != null ? SaintFeastData.getUpcomingFeast(saint) : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      children: [
        // Name input
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF673AB7), Color(0xFF512DA8)]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.person_rounded, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Personal Feast Day',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter your baptism (saint) name to see your personal feast day.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Thomas, Mary, Francis...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
                onChanged: (val) {
                  setState(() => _baptismName = val);
                  StorageService.saveBaptismName(val);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_baptismName.isEmpty) ...[
          _infoCard(
            title: '✝ What is a Patron Saint?',
            content:
                'When you are baptised, you receive a Christian name — often the name of a saint who becomes your heavenly patron. That saint\'s feast day is sometimes called your "name day" or personal feast day. Enter your name above to discover it!',
            color: const Color(0xFF673AB7),
            theme: theme,
          ),
        ] else if (saint == null) ...[
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('Saint not found',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  '"$_baptismName" wasn\'t found in our database. Try a shorter or English spelling (e.g. "Thomas" instead of "Tomas").',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ] else ...[
          // Feast Day Card
          if (isToday)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFFA000), Color(0xFFFF6F00)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  const Text('Happy Feast Day!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    widget.lang == 'ta'
                        ? saint.greetingTa
                        : widget.lang == 'hi'
                            ? saint.greetingHi
                            : saint.greeting,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF673AB7).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Color(0xFF673AB7), size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'St. ${saint.name.substring(0, 1).toUpperCase()}${saint.name.substring(1)}',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Your Patron Saint',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF673AB7).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _feastDateDetail('Feast Date', '${_monthName(saint.month)} ${saint.day}'),
                        Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                        _feastDateDetail(
                          'Days Away',
                          upcoming != null ? '${upcoming['days']}' : 'N/A',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.lang == 'ta'
                        ? saint.greetingTa
                        : widget.lang == 'hi'
                            ? saint.greetingHi
                            : saint.greeting,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          _infoCard(
            title: '🙏 Patron Saint Prayer',
            content:
                'Dear St. ${saint.name.substring(0, 1).toUpperCase()}${saint.name.substring(1)}, '
                'you are my heavenly patron and intercessor before God. '
                'Pray for me, that I may grow daily in faith, hope, and love. '
                'Help me to imitate your virtues and to keep my eyes fixed on Christ. '
                'May I one day join you in eternal joy. Amen.',
            color: const Color(0xFF673AB7),
            theme: theme,
          ),
        ],
      ],
    );
  }

  Widget _feastDateDetail(String label, String value) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF673AB7))),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      );

  Widget _infoCard({
    required String title,
    required String content,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 14)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[month - 1];
  }
}
