import 'package:flutter/material.dart';
import '../../config/translations.dart';
import '../../data/rosary_data.dart';
import '../../data/models.dart';

class RosaryPrayersScreen extends StatefulWidget {
  final String lang;
  const RosaryPrayersScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<RosaryPrayersScreen> createState() => _RosaryPrayersScreenState();
}

class _RosaryPrayersScreenState extends State<RosaryPrayersScreen> {
  String selectedMystery = 'Joyful';

  Color _getMysteryColor(String mystery) {
    switch (mystery) {
      case 'Joyful':
        return const Color(0xFFFFA000);
      case 'Sorrowful':
        return const Color(0xFFD32F2F);
      case 'Glorious':
        return const Color(0xFFFBC02D);
      case 'Luminous':
        return const Color(0xFF0288D1);
      default:
        return Colors.indigo;
    }
  }

  String _getMysteryDays(String mystery) {
    // Basic day logic (can be translated if needed)
    switch (mystery) {
      case 'Joyful':
        return "Mon & Sat";
      case 'Sorrowful':
        return "Tue & Fri";
      case 'Glorious':
        return "Wed & Sun";
      case 'Luminous':
        return "Thu";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getMysteryColor(selectedMystery);
    // Fetch Translated Content
    final mysteries = RosaryDatabase.getMysteries(selectedMystery, widget.lang);
    final prayers = RosaryDatabase.getPrayers(widget.lang);

    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: bgColor,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                bottom: 16,
                left: 50,
                right: 50,
              ),
              centerTitle: true,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  AppTranslations.get('rosary_prayers', widget.lang),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [themeColor.withOpacity(0.1), bgColor],
                  ),
                ),
              ),
            ),
          ),

          // 2. Mystery Selector
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children:
                    ['Joyful', 'Sorrowful', 'Glorious', 'Luminous'].map((m) {
                      final isSelected = selectedMystery == m;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ChoiceChip(
                          label: Text(
                            AppTranslations.get(m.toLowerCase(), widget.lang),
                            style: TextStyle(
                              color: isSelected ? Colors.white : textColor,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected:
                              (val) => setState(() => selectedMystery = m),
                          selectedColor: themeColor,
                          backgroundColor: cardColor,
                          elevation: isSelected ? 4 : 0,
                          pressElevation: 2,
                          side: BorderSide(
                            color:
                                isSelected
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          // 3. Header Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
              child: Column(
                children: [
                  Text(
                    "${AppTranslations.get(selectedMystery.toLowerCase(), widget.lang)} ${AppTranslations.get('mysteries', widget.lang)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                      color: themeColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${AppTranslations.get('prayed_on', widget.lang)}: ${_getMysteryDays(selectedMystery)}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: themeColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Mystery Timeline (UPDATED)
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final mystery = mysteries[index];
              final isLast = index == mysteries.length - 1;

              return Stack(
                children: [
                  // LAYER 1: The Vertical Line
                  // We draw a line from top to bottom of the entire row
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 29, // (Width 60 / 2) - (Line Width 2 / 2)
                    child: Container(
                      width: 2,
                      color: themeColor.withOpacity(0.3),
                    ),
                  ),

                  // LAYER 2: Hide line extensions for First/Last items
                  // Hides the line going UP if it's the first item
                  if (index == 0)
                    Positioned(
                      top: 0,
                      height: 36, // Height to center of dot
                      left: 29,
                      child: Container(width: 2, color: bgColor),
                    ),
                  // Hides the line going DOWN if it's the last item
                  if (isLast)
                    Positioned(
                      bottom: 0,
                      top: 36, // Start hiding from center of dot downwards
                      left: 29,
                      child: Container(width: 2, color: bgColor),
                    ),

                  // LAYER 3: The Actual Content (Dot + Card)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // The Number Bubble (Dot)
                        SizedBox(
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ), // Align with Card Title
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: themeColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // The Card (Flexible Height for Tamil)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: _buildElegantMysteryCard(
                              mystery,
                              themeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }, childCount: mysteries.length),
          ),
          // 5. Common Prayers List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    AppTranslations.get('prayers_header', widget.lang),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...prayers.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPrayerCard(e.key, e.value),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantMysteryCard(MysteryModel mystery, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16),
          title: Text(
            mystery.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              children: [
                Icon(Icons.spa_rounded, size: 14, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    mystery.fruit,
                    style: TextStyle(
                      fontSize: 13,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mystery.scripture,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    mystery.description,
                    style: const TextStyle(fontSize: 15, height: 1.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerCard(String title, String content) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              content,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                fontFamily: 'Serif',
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
