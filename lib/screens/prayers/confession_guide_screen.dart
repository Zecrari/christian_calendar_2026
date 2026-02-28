import 'package:flutter/material.dart';
import '../../config/translations.dart';
import '../../data/confession_data.dart';

class ConfessionGuideScreen extends StatefulWidget {
  final String lang;
  const ConfessionGuideScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<ConfessionGuideScreen> createState() => _ConfessionGuideScreenState();
}

class _ConfessionGuideScreenState extends State<ConfessionGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, bool> _checkedSins = {};

  static const _accentColor = Color(0xFF673AB7);

  late List<Map<String, dynamic>> _commandments;
  late Map<String, String> _prayers;
  late List<Map<String, dynamic>> _steps;

  @override
  void initState() {
    super.initState();
    _commandments = ConfessionData.getCommandments(widget.lang);
    _prayers = ConfessionData.getPrayers(widget.lang);
    _steps = ConfessionData.getSteps(widget.lang);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('confession_guide', widget.lang),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _accentColor,
          labelColor: _accentColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(icon: const Icon(Icons.checklist_rounded), text: AppTranslations.get('examination_of_conscience', widget.lang).split(' ')[0]),
            Tab(icon: const Icon(Icons.menu_book_rounded), text: AppTranslations.get('act_of_contrition', widget.lang)),
            Tab(icon: const Icon(Icons.help_outline_rounded), text: AppTranslations.get('how_to', widget.lang)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExaminationTab(theme),
          _buildActOfContritionTab(theme),
          _buildHowToTab(theme),
        ],
      ),
    );
  }

  Widget _buildExaminationTab(ThemeData theme) {
    final checked = _checkedSins.values.where((v) => v).length;
    final total = _commandments.fold<int>(
        0, (sum, c) => sum + (c['sins'] as List).length);

    return Column(
      children: [
        // Progress bar
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF673AB7), Color(0xFF512DA8)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.checklist_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslations.get('examination_of_conscience', widget.lang),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Text(
                      AppTranslations.get('check_each_area', widget.lang),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '$checked/$total',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            itemCount: _commandments.length,
            itemBuilder: (ctx, i) {
              final cmd = _commandments[i];
              return _buildCommandmentSection(cmd, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommandmentSection(Map<String, dynamic> cmd, ThemeData theme) {
    final sins = cmd['sins'] as List<String>;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                cmd['num'] as String,
                style: const TextStyle(
                  color: _accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          title: Text(
            cmd['commandment'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              height: 1.3,
            ),
          ),
          children: sins.map((sin) {
            final key = '${cmd['num']}_$sin';
            return CheckboxListTile(
              value: _checkedSins[key] ?? false,
              onChanged: (val) =>
                  setState(() => _checkedSins[key] = val ?? false),
              title: Text(sin, style: const TextStyle(fontSize: 14, height: 1.4)),
              activeColor: _accentColor,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActOfContritionTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _accentColor.withOpacity(0.1),
                  _accentColor.withOpacity(0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _accentColor.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Icon(Icons.volunteer_activism_rounded,
                    color: _accentColor, size: 40),
                const SizedBox(height: 16),
                Text(
                  AppTranslations.get('act_of_contrition', widget.lang),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _accentColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _prayers['act_of_contrition'] ?? '',
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 17, height: 1.8, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _prayerCard(
            AppTranslations.get('short_act', widget.lang),
            _prayers['short_act'] ?? '',
            Icons.favorite_rounded,
            Colors.red,
            theme,
          ),
          const SizedBox(height: 12),
          _prayerCard(
            AppTranslations.get('prayer_before_confession', widget.lang),
            _prayers['before_confession'] ?? '',
            Icons.lightbulb_rounded,
            Colors.orange,
            theme,
          ),
          const SizedBox(height: 12),
          _prayerCard(
            AppTranslations.get('prayer_after_confession', widget.lang),
            _prayers['after_confession'] ?? '',
            Icons.check_circle_rounded,
            Colors.green,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _prayerCard(String title, String text, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(fontSize: 14, height: 1.6, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildHowToTab(ThemeData theme) {
    final baseColors = [
      const Color(0xFF673AB7),
      const Color(0xFF1565C0),
      const Color(0xFFE65100),
      const Color(0xFF2E7D32),
      const Color(0xFF6A1B9A),
      const Color(0xFFD32F2F),
      const Color(0xFF00796B),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _accentColor.withOpacity(0.2)),
          ),
          child: Text(
            '✝  ${_prayers['quote'] ?? ''}',
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        for (int i = 0; i < _steps.length; i++)
          _buildStep(_steps[i], baseColors[i % baseColors.length], '${i + 1}', theme),
      ],
    );
  }

  Widget _buildStep(Map<String, dynamic> step, Color color, String numStr, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(child: Text(numStr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step['title'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)),
                const SizedBox(height: 4),
                Text(step['desc'] as String, style: const TextStyle(fontSize: 14, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
