import 'package:flutter/material.dart';
import '../../config/translations.dart';
import '../../data/novena_data.dart';

class NovenaScreen extends StatefulWidget {
  final String lang;
  const NovenaScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<NovenaScreen> createState() => _NovenaScreenState();
}

class _NovenaScreenState extends State<NovenaScreen>
    with SingleTickerProviderStateMixin {
  int _selectedNovena = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  late List<Map<String, dynamic>> _novenas;

  @override
  void initState() {
    super.initState();
    _novenas = NovenaData.getNovenas(widget.lang);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _selectNovena(int index) {
    _fadeController.reset();
    setState(() => _selectedNovena = index);
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final novena = _novenas[_selectedNovena];
    final color = novena['color'] as Color;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                AppTranslations.get('daily_novena', widget.lang),
                style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.3), theme.scaffoldBackgroundColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(novena['icon'] as IconData,
                      color: color, size: 60),
                ),
              ),
            ),
          ),

          // Novena Selector
          SliverToBoxAdapter(
            child: SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _novenas.length,
                itemBuilder: (ctx, i) {
                  final n = _novenas[i];
                  final selected = _selectedNovena == i;
                  final c = n['color'] as Color;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => _selectNovena(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: selected
                              ? LinearGradient(colors: [c, c.withOpacity(0.7)])
                              : null,
                          color: selected ? null : theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: selected
                                  ? Colors.transparent
                                  : c.withOpacity(0.3)),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: c.withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(n['icon'] as IconData,
                                color: selected ? Colors.white : c, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              n['title'] as String,
                              style: TextStyle(
                                color: selected ? Colors.white : c,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Intro Card
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [color.withOpacity(0.15), color.withOpacity(0.05)]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(novena['icon'] as IconData, color: color, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            novena['title'] as String,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      novena['intro'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 9 Day Prayers
          SliverList(
            delegate: SliverChildBuilderDelegate((ctx, index) {
              final prayers = novena['prayers'] as List;
              final p = prayers[index] as Map<String, dynamic>;
              return _buildDayCard(p, color, index, theme);
            }, childCount: (novena['prayers'] as List).length),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildDayCard(
      Map<String, dynamic> prayer, Color color, int index, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide.none,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${prayer['day']}',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
        title: Text(
          prayer['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
            AppTranslations.get('day_of', widget.lang).replaceAll('{0}', '${prayer['day']}').replaceAll('{1}', '9'),
            style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              prayer['prayer'] as String,
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
    );
  }
}
