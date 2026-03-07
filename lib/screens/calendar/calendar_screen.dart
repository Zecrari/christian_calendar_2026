import 'package:christian_calendar/widgets/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import '../../data/calendar_data.dart';
import '../../data/bible_data.dart';
import '../../data/saints_data.dart';
import '../../data/models.dart';
import '../../config/translations.dart';

class CalendarScreen extends StatefulWidget {
  final String lang;
  const CalendarScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late PageController _pageController;

  // 1. START DATE: December 2025
  final DateTime _startBaseDate = DateTime(2025, 12);

  DateTime _focusedMonth = DateTime(2025, 12);
  DateTime _selectedDate = DateTime.now();
  ChristianEvent? _selectedEvent;

  @override
  void initState() {
    super.initState();
    // Calculate initial page based on difference from Dec 2025
    // If today is Dec 2025, page is 0. If Jan 2026, page is 1.
    final now = DateTime.now();
    int initialPage = 0;
    if (now.isAfter(_startBaseDate)) {
      initialPage =
          (now.year - _startBaseDate.year) * 12 +
          (now.month - _startBaseDate.month);
    }

    _pageController = PageController(initialPage: initialPage);
    _focusedMonth = now;
    _updateSelectedDay(now);
  }

  void _updateSelectedDay(DateTime date) {
    setState(() {
      _selectedDate = date;
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      _selectedEvent = ChristianEvents.getEvent(key, widget.lang);
    });
  }

  Color _getMonthThemeColor(int month) {
    if (month == 3) return const Color(0xFF673AB7); // Lent (Purple)
    if (month == 4) return const Color(0xFFFFA000); // Easter (Gold)
    if (month == 12) return const Color(0xFFD32F2F); // Christmas (Red)
    return const Color(0xFF388E3C); // Ordinary Time (Green)
  }

  @override
  Widget build(BuildContext context) {
    final themeColor =
        _selectedEvent?.color ?? _getMonthThemeColor(_focusedMonth.month);
    final monthName = AppTranslations.getMonth(
      _focusedMonth.month,
      widget.lang,
    );

    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // ==========================================
          // 1. APP BAR (Navigation)
          // ==========================================
          SliverAppBar(
            pinned: true,
            expandedHeight: 70,
            backgroundColor: bgColor,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.today_rounded, color: themeColor),
              onPressed: () {
                // Jump to Today
                final now = DateTime.now();
                int page =
                    (now.year - _startBaseDate.year) * 12 +
                    (now.month - _startBaseDate.month);
                _pageController.animateToPage(
                  page,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
                setState(() {
                  _focusedMonth = now;
                  _updateSelectedDay(now);
                });
              },
            ),
            centerTitle: true,
            title: Text(
              "$monthName ${_focusedMonth.year}".toUpperCase(),
              style: TextStyle(
                color: themeColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed:
                    () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed:
                    () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
              ),
            ],
          ),

          // ==========================================
          // 2. CALENDAR MONTH GRID (PageView)
          // ==========================================
          SliverToBoxAdapter(
            child: SizedBox(
              height: 340,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged:
                    (index) => setState(() {
                      _focusedMonth = DateTime(
                        _startBaseDate.year,
                        _startBaseDate.month + index,
                      );
                    }),
                itemBuilder: (context, index) {
                  final monthDate = DateTime(
                    _startBaseDate.year,
                    _startBaseDate.month + index,
                  );
                  return _buildMonthGrid(monthDate, cardColor, textColor);
                },
              ),
            ),
          ),

          // ==========================================
          // 3. SELECTED DAY DETAIL CARD
          // ==========================================
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: _buildDayDetailCard(themeColor, cardColor, textColor),
            ),
          ),

          // ==========================================
          // 4. UPCOMING EVENTS HEADER
          // ==========================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: Text(
                "${AppTranslations.get('upcoming_in', widget.lang)} ${monthName.toUpperCase()}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          // ==========================================
          // 5. UPCOMING EVENTS LIST (Dynamic)
          // ==========================================
          _buildUpcomingEventsList(cardColor, textColor),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER: Build the Grid for a Month
  // ---------------------------------------------------------------------------
  Widget _buildMonthGrid(
    DateTime monthDate,
    Color cardColor,
    Color? textColor,
  ) {
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final firstWeekday = DateTime(monthDate.year, monthDate.month, 1).weekday;
    final startingOffset = firstWeekday == 7 ? 0 : firstWeekday;
    final weekdays = AppTranslations.getWeekdays(widget.lang);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Weekday Headers
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  weekdays
                      .map(
                        (d) => Text(
                          d,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                (d == 'S' || d == 'ஞா')
                                    ? Colors.redAccent
                                    : Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: Theme.of(context).dividerColor,
          ),

          // Days Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemCount: 42,
              itemBuilder: (context, index) {
                final dayNumber = index - startingOffset + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth)
                  return const SizedBox();

                final date = DateTime(
                  monthDate.year,
                  monthDate.month,
                  dayNumber,
                );
                final key =
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

                final event = ChristianEvents.getEvent(key, widget.lang);

                // CHECK SPECIAL DAY (Has Event)
                final isSpecialDay = event != null;

                final isSelected =
                    date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;

                final isToday =
                    date.day == DateTime.now().day &&
                    date.month == DateTime.now().month &&
                    date.year == DateTime.now().year;

                return GestureDetector(
                  onTap: () => _updateSelectedDay(date),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isSelected
                              ? (event?.color ??
                                  const Color(0xFF673AB7)) // Selected Color
                              : (isToday
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest
                                  : Colors.transparent),
                      border:
                          isSelected
                              ? null
                              : Border.all(
                                // GOLD BORDER FOR SPECIAL DAYS
                                color:
                                    isSpecialDay
                                        ? Colors.amber
                                        : (isToday
                                            ? Colors.grey.withOpacity(0.3)
                                            : Colors.transparent),
                                width: isSpecialDay ? 1.5 : 1,
                              ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : (date.weekday == 7
                                        ? Colors.red
                                        : (isSpecialDay
                                            ? Colors.deepOrange
                                            : textColor)),
                            fontWeight:
                                (isSelected || isToday || isSpecialDay)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        if (event != null && !isSelected)
                          Positioned(
                            bottom: 6,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: event.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER: Build the Detail Card for Selected Day
  // ---------------------------------------------------------------------------
  Widget _buildDayDetailCard(
    Color themeColor,
    Color cardColor,
    Color? textColor,
  ) {
    final isSunday = _selectedDate.weekday == 7;
    // Uses the fixed SaintsDatabase logic (Previous Answer)
    final saint = SaintsDatabase.getSaint(
      _selectedDate.month,
      _selectedDate.day,
      widget.lang,
    );
    final verseData = DailyVerses.getVerse(_selectedDate.day, widget.lang);

    String title =
        _selectedEvent?.name ??
        (isSunday
            ? AppTranslations.get('lords_day', widget.lang)
            : AppTranslations.get('ferial_day', widget.lang));

    String subtitle =
        isSunday
            ? AppTranslations.get('celebrate_resurrection', widget.lang)
            : "${AppTranslations.get('week', widget.lang)} ${_getWeekNumber(_selectedDate)} ${AppTranslations.get('ordinary_time', widget.lang)}";

    if (_selectedEvent != null)
      subtitle = AppTranslations.get('feast_day', widget.lang);

    String scripture = _selectedEvent?.verseText ?? verseData['text']!;
    String ref = _selectedEvent?.reference ?? verseData['reference']!;

    String dateBadge =
        "${AppTranslations.getWeekdays(widget.lang)[_selectedDate.weekday % 7]}, ${AppTranslations.getMonth(_selectedDate.month, widget.lang)} ${_selectedDate.day}, ${_selectedDate.year}";

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  dateBadge.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: themeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(height: 1, indent: 40, endIndent: 40),
                const SizedBox(height: 24),

                // Scripture Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: themeColor.withOpacity(0.4),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scripture,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Serif',
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ref,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Saint Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: cardColor,
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTranslations.get('commemoration', widget.lang),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              saint.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER: Dynamic List of Upcoming Events
  // ---------------------------------------------------------------------------
  Widget _buildUpcomingEventsList(Color cardColor, Color? textColor) {
    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    List<Map<String, dynamic>> upcomingEvents = [];

    // Find all events in the current month
    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, i);
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final event = ChristianEvents.getEvent(key, widget.lang);

      if (event != null) {
        upcomingEvents.add({
          'day': i,
          'title': event.name,
          'color': event.color,
          'date': date,
        });
      }
    }

    if (upcomingEvents.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            (widget.lang == 'ta')
                ? "இந்த மாதம் வேறு விழாக்கள் இல்லை."
                : "No major festivals this month.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = upcomingEvents[index];
        final date = item['date'] as DateTime;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: GestureDetector(
            onTap: () {
              _updateSelectedDay(date);
              // Scroll to top to see details
              Scrollable.ensureVisible(context, alignment: 0.0);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "${item['day']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: item['color'],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      }, childCount: upcomingEvents.length),
    );
  }

  int _getWeekNumber(DateTime d) => ((d.day / 7).ceil());
}
