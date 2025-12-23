import 'package:christian_calendar/version/main.dart';
import 'package:christian_calendar/version/saints_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'rosary_db.dart'; // Ensure this import exists
import 'data.dart';
import 'package:intl/intl.dart';

// Helper for smooth cards
class SmoothCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final VoidCallback? onTap;

  const SmoothCard({
    super.key,
    required this.child,
    this.margin,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Flat elegant look
      color: color ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Smooth corners
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }
}

// ============================================================================
// 2. DETAILED CALENDAR SCREEN (FIXED & ELEGANT)
// ============================================================================
// ... inside lib/screens.dart

// ============================================================================
// 2. PREMIER LITURGICAL CALENDAR
// ============================================================================
class CalendarScreen extends StatefulWidget {
  final String lang;
  const CalendarScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // We use a PageController for smooth month swiping
  late PageController _pageController;
  DateTime _focusedMonth = DateTime(2026, 1);
  DateTime _selectedDate = DateTime.now();

  // Cache the events for the selected day to avoid repeated lookups
  ChristianEvent? _selectedEvent;

  @override
  void initState() {
    super.initState();
    // Initialize controller to the focused month (default Jan 2026)
    // We calculate the initial page index assuming a range starting from 2020 or similar
    // For simplicity here, let's just center it or start at 0 for Jan 2026
    _pageController = PageController(initialPage: 0);
    _updateSelectedDay(_selectedDate);
  }

  void _updateSelectedDay(DateTime date) {
    setState(() {
      _selectedDate = date;
      final key = _formatDateKey(date);
      _selectedEvent = ChristianEvents.events[key];
    });
  }

  // Calculate Liturgical Season Color for the whole month view header
  Color _getMonthThemeColor(int month) {
    // Rough approximation for 2026 seasons
    if (month == 3) return const Color(0xFF673AB7); // March (Lent) - Purple
    if (month == 4) return const Color(0xFFFFA000); // April (Easter) - Gold
    if (month == 12)
      return const Color(0xFF673AB7); // December (Advent) - Purple
    return const Color(0xFF388E3C); // Ordinary Time - Green
  }

  @override
  Widget build(BuildContext context) {
    final themeColor =
        _selectedEvent?.color ?? _getMonthThemeColor(_focusedMonth.month);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Cream/Parchment
      body: CustomScrollView(
        slivers: [
          // 1. PREMIER APP BAR (Dynamic Color)
          SliverAppBar(
            pinned: true,
            expandedHeight: 70,
            backgroundColor: const Color(0xFFFDFBF7),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.today_rounded, color: themeColor),
              onPressed: () {
                final now = DateTime.now();
                setState(() {
                  _focusedMonth = DateTime(now.year, now.month);
                  _updateSelectedDay(now);
                  // Reset page controller logic would go here in a full infinite scroll impl
                });
              },
            ),
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_focusedMonth).toUpperCase(),
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.chevron_left_rounded, color: Colors.black87),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.chevron_right_rounded, color: Colors.black87),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),

          // 2. CALENDAR PAGER
          SliverToBoxAdapter(
            child: SizedBox(
              height: 340, // Fixed height for calendar grid
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    // Logic to update focused month based on index
                    // Assuming index 0 is Jan 2026
                    _focusedMonth = DateTime(2026, 1 + index);
                  });
                },
                itemBuilder: (context, index) {
                  // Calculate month for this page index
                  final monthDate = DateTime(2026, 1 + index);
                  return _buildElegantMonthGrid(monthDate);
                },
              ),
            ),
          ),

          // 3. DAY DETAIL CARD (The "Premier" View)
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: _buildDayDetailCard(themeColor)),
          ),

          // 4. BOTTOM SPACING
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildElegantMonthGrid(DateTime monthDate) {
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final firstWeekday = DateTime(monthDate.year, monthDate.month, 1).weekday;
    final startingOffset = firstWeekday == 7 ? 0 : firstWeekday; // Sunday start

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Day Headers
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                      .map(
                        (d) => Text(
                          d,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                d == 'S'
                                    ? Colors.redAccent
                                    : Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),

          // The Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemCount: 42, // Fixed 6 rows
              itemBuilder: (context, index) {
                final dayNumber = index - startingOffset + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth)
                  return const SizedBox();

                final date = DateTime(
                  monthDate.year,
                  monthDate.month,
                  dayNumber,
                );
                final key = _formatDateKey(date);
                final event = ChristianEvents.events[key];
                final isSelected = _isSameDay(date, _selectedDate);
                final isToday = _isSameDay(date, DateTime.now());

                return GestureDetector(
                  onTap: () => _updateSelectedDay(date),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isSelected
                              ? (event?.color ?? Colors.black87)
                              : (isToday
                                  ? Colors.grey.shade200
                                  : Colors.transparent),
                      border:
                          isToday && !isSelected
                              ? Border.all(color: Colors.black12)
                              : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight:
                                isSelected || isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        // Event Dot
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

  Widget _buildDayDetailCard(Color themeColor) {
    // Data Preparation
    final isSunday = _selectedDate.weekday == 7;
    final saint = SaintsDatabase.getSaint(
      _selectedDate.month,
      _selectedDate.day,
    );

    // Determine Display Data
    String title =
        _selectedEvent?.name ?? (isSunday ? "The Lord's Day" : "Ferial Day");
    String subtitle =
        isSunday
            ? "Celebrate the Resurrection"
            : "Week ${_getWeekNumber(_selectedDate)} in Ordinary Time";
    if (_selectedEvent != null) subtitle = "Holy Day of Obligation / Feast";

    String scripture =
        _selectedEvent?.verseText ??
        DailyVerses.getVerse(_selectedDate.day)['text']!;
    String ref =
        _selectedEvent?.reference ??
        DailyVerses.getVerse(_selectedDate.day)['reference']!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          // 1. Color Banner (Vestment Color)
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
                // Date Badge
                Text(
                  DateFormat(
                    'EEEE, MMMM d, yyyy',
                  ).format(_selectedDate).toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 16),

                // Main Feast Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    color: Colors.black87,
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
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Serif',
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

                // Saint of the Day Footer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F5F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "COMMEMORATION",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            saint.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

  // --- HELPERS ---
  String _formatDateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  int _getWeekNumber(DateTime d) =>
      ((d.day / 7).ceil()); // Simplified week logic
}

// ============================================================================
// 3. ELEGANT PRAYER REMINDERS (With Local Notifications)
// ============================================================================
// ============================================================================
// 3. ELEGANT PRAYER REMINDERS (Persistent & Bible Integrated)
// ============================================================================
class PrayerRemindersScreen extends StatefulWidget {
  final String lang;
  const PrayerRemindersScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<PrayerRemindersScreen> createState() => _PrayerRemindersScreenState();
}

class _PrayerRemindersScreenState extends State<PrayerRemindersScreen> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<PrayerReminder> reminders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load from Local Storage
    final saved = await StorageService.loadReminders();
    if (saved.isNotEmpty) {
      setState(() {
        reminders = saved;
        isLoading = false;
      });
    } else {
      // Default Initial Data (Only if storage is empty)
      setState(() {
        reminders = [
          PrayerReminder(
            name: AppTranslations.get('morning_prayer', widget.lang),
            time: const TimeOfDay(hour: 6, minute: 0),
            enabled: true,
            iconCode: Icons.wb_sunny_rounded.codePoint,
            colorValue: Colors.orange.value,
            frequency: 'Daily',
          ),
          PrayerReminder(
            name: AppTranslations.get('noon_prayer', widget.lang),
            time: const TimeOfDay(hour: 12, minute: 0),
            enabled: true,
            iconCode: Icons.wb_sunny_outlined.codePoint,
            colorValue: Colors.amber.value,
            frequency: 'Daily',
          ),
          PrayerReminder(
            name: AppTranslations.get('night_prayer', widget.lang),
            time: const TimeOfDay(hour: 21, minute: 0),
            enabled: false,
            iconCode: Icons.bedtime_rounded.codePoint,
            colorValue: Colors.indigo.value,
            frequency: 'Daily',
          ),
        ];
        isLoading = false;
      });
      StorageService.saveReminders(reminders);
    }
  }

  Future<void> _saveData() async {
    await StorageService.saveReminders(reminders);
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    await _notificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  // --- SCHEDULE WITH FREQUENCY & BIBLE VERSE ---
  Future<void> _scheduleNotification(int id, PrayerReminder reminder) async {
    // 1. Get a Random Bible Verse for the Body
    final today = DateTime.now();
    // Simple hash to pick a verse based on the day so it doesn't change every second
    final verse = DailyVerses.getVerse(today.day + id);
    final String bodyText = "${verse['text']} - ${verse['reference']}";

    // 2. Determine Frequency
    DateTimeComponents? matchComponent;
    if (reminder.frequency == 'Daily') matchComponent = DateTimeComponents.time;
    if (reminder.frequency == 'Weekly')
      matchComponent = DateTimeComponents.dayOfWeekAndTime;
    if (reminder.frequency == 'Monthly')
      matchComponent = DateTimeComponents.dayOfMonthAndTime;

    // 3. Calculate Date
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      reminder.time.hour,
      reminder.time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // 4. Schedule
    await _notificationsPlugin.zonedSchedule(
      id,
      "🙏 ${reminder.name}", // Title
      bodyText, // Body (Bible Verse)
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_channel',
          'Prayer Reminders',
          channelDescription: 'Daily prayer alerts with scripture',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            '',
          ), // Allows long bible verses
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchComponent,
    );
  }

  Future<void> _cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  void _addOrEditReminder({PrayerReminder? existing, int? index}) async {
    TimeOfDay selectedTime = existing?.time ?? TimeOfDay.now();
    String selectedFreq = existing?.frequency ?? 'Daily';
    TextEditingController nameController = TextEditingController(
      text: existing?.name ?? "My Prayer",
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => StatefulBuilder(
            // Use StatefulBuilder to update sheet UI
            builder: (context, setSheetState) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Set Prayer Reminder",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Name Input
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Prayer Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Time Picker Row
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.grey),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () async {
                            final t = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (t != null)
                              setSheetState(() => selectedTime = t);
                          },
                          child: Text(
                            selectedTime.format(context),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Frequency Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedFreq,
                      decoration: InputDecoration(
                        labelText: "Repeat",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items:
                          ['Daily', 'Weekly', 'Monthly']
                              .map(
                                (f) =>
                                    DropdownMenuItem(value: f, child: Text(f)),
                              )
                              .toList(),
                      onChanged:
                          (val) => setSheetState(() => selectedFreq = val!),
                    ),
                    const SizedBox(height: 24),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          final newReminder = PrayerReminder(
                            name: nameController.text,
                            time: selectedTime,
                            enabled: true,
                            iconCode:
                                Icons.star_rounded.codePoint, // Default icon
                            colorValue: Colors.blue.value, // Default color
                            frequency: selectedFreq,
                          );

                          setState(() {
                            if (index != null) {
                              reminders[index] = newReminder;
                            } else {
                              reminders.add(newReminder);
                            }
                          });
                          _saveData();
                          _scheduleNotification(
                            index ?? reminders.length - 1,
                            newReminder,
                          );
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("Save Reminder"),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text(AppTranslations.get('prayer_reminders', widget.lang)),
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final r = reminders[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildElegantReminderCard(index, r),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditReminder(),
        icon: const Icon(Icons.add_alarm_rounded),
        label: const Text("Add"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildElegantReminderCard(int index, PrayerReminder reminder) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(reminder.colorValue).withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _addOrEditReminder(existing: reminder, index: index),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(reminder.colorValue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    IconData(reminder.iconCode, fontFamily: 'MaterialIcons'),
                    color: Color(reminder.colorValue),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.time.format(context),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Serif',
                        ),
                      ),
                      Text(
                        "${reminder.name} • ${reminder.frequency}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: reminder.enabled,
                  activeColor: Color(reminder.colorValue),
                  onChanged: (val) {
                    setState(() {
                      reminders[index] = PrayerReminder(
                        name: reminder.name,
                        time: reminder.time,
                        enabled: val,
                        iconCode: reminder.iconCode,
                        colorValue: reminder.colorValue,
                        frequency: reminder.frequency,
                      );
                    });
                    _saveData();
                    if (val)
                      _scheduleNotification(index, reminders[index]);
                    else
                      _cancelNotification(index);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 4. ELEGANT BIBLE READER (Fixed Font Size Slider)
// ============================================================================
class BibleReaderScreen extends StatefulWidget {
  final String lang;
  const BibleReaderScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  String selectedBook = 'Genesis';
  int selectedChapter = 1;
  bool isLoading = true;

  // Font Size State
  double fontSize = 18.0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadBibleData();
  }

  @override
  void didUpdateWidget(BibleReaderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lang != widget.lang) {
      _loadBibleData();
    }
  }

  Future<void> _loadBibleData() async {
    setState(() => isLoading = true);
    await BibleData.load(widget.lang);

    if (BibleData.availableBooks.isNotEmpty) {
      if (!BibleData.availableBooks.contains(selectedBook)) {
        selectedBook = BibleData.availableBooks[0];
        selectedChapter = 1;
      }
    }
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Get Text
    String chapterText = BibleData.getChapterText(
      selectedBook,
      selectedChapter,
    );

    // Drop Cap Logic
    String firstLetter = "";
    String remainingText = "";
    if (chapterText.isNotEmpty && chapterText != "Loading...") {
      // Find the first letter (handling potential whitespace)
      String trimmed = chapterText.trimLeft();
      if (trimmed.isNotEmpty) {
        firstLetter = trimmed.substring(0, 1);
        remainingText = trimmed.substring(1);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Parchment color
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // --- APP BAR ---
                      SliverAppBar(
                        floating: true,
                        snap: true,
                        backgroundColor: const Color(0xFFFDFBF7),
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        centerTitle: true,
                        title: Text(
                          AppTranslations.get('bible_reader', widget.lang),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.search_rounded),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: BibleSearchDelegate(
                                  onVerseSelected: (book, chapter) {
                                    setState(() {
                                      selectedBook = book;
                                      selectedChapter = chapter;
                                    });
                                    _scrollController.jumpTo(0);
                                  },
                                ),
                              );
                            },
                          ),
                          // FONT SETTINGS BUTTON
                          IconButton(
                            icon: const Icon(Icons.format_size_rounded),
                            color: Theme.of(context).primaryColor,
                            onPressed: () => _showFormatSettings(),
                          ),
                        ],
                      ),

                      // --- BOOK & CHAPTER TITLE ---
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _showBookSelector(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    selectedBook.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Chapter $selectedChapter",
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontFamily: 'Serif',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // --- BIBLE TEXT CONTENT ---
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverToBoxAdapter(
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: fontSize, // <--- DYNAMIC FONT SIZE
                                color: Colors.black87,
                                height: 1.8,
                                fontFamily:
                                    'Serif', // Ensure font supports Tamil if needed
                              ),
                              children: [
                                // Drop Cap (First Letter)
                                TextSpan(
                                  text: firstLetter,
                                  style: TextStyle(
                                    fontSize:
                                        fontSize * 3.0, // Scales with slider
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF673AB7),
                                    height: 0.8,
                                  ),
                                ),
                                // Remaining Text
                                TextSpan(text: remainingText),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 120)),
                    ],
                  ),

                  // --- BOTTOM NAVIGATION BAR ---
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left_rounded),
                              onPressed: () => _navigateChapter(-1),
                            ),
                            GestureDetector(
                              onTap: () => _showBookSelector(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF673AB7),
                                      Color(0xFF512DA8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "$selectedBook $selectedChapter",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right_rounded),
                              onPressed: () => _navigateChapter(1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  void _navigateChapter(int change) {
    if (change == -1 && selectedChapter > 1) {
      setState(() => selectedChapter--);
      _scrollController.jumpTo(0);
    } else if (change == 1 &&
        selectedChapter < BibleData.getChapterCount(selectedBook)) {
      setState(() => selectedChapter++);
      _scrollController.jumpTo(0);
    }
  }

  // --- FIXED FONT SETTINGS MODAL ---
  void _showFormatSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        // Use StatefulBuilder so the Slider updates smoothly while dragging
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Text Size",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        "A",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: fontSize,
                          min: 12.0,
                          max: 40.0, // Increased range
                          divisions: 14,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (val) {
                            // 1. Update the Slider UI immediately
                            setModalState(() => fontSize = val);
                            // 2. Update the Main Screen UI (The Bible Text)
                            this.setState(() => fontSize = val);
                          },
                        ),
                      ),
                      const Text(
                        "A",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Size: ${fontSize.toInt()}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showBookSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (_, controller) => Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDFBF7),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          AppTranslations.get('bible_reader', widget.lang),
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Serif',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          controller: controller,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.5,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                          itemCount: BibleData.availableBooks.length,
                          itemBuilder: (ctx, i) {
                            final book = BibleData.availableBooks[i];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedBook = book;
                                  selectedChapter = 1;
                                });
                                Navigator.pop(ctx);
                                _scrollController.jumpTo(0);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border(
                                    left: BorderSide(
                                      color:
                                          i < 39
                                              ? const Color(0xFF673AB7)
                                              : const Color(0xFFFFA000),
                                      width: 4,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    book,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }
}

// --- SEARCH DELEGATE (No Changes needed here, keeping for context) ---
class BibleSearchDelegate extends SearchDelegate {
  final Function(String, int) onVerseSelected;
  BibleSearchDelegate({required this.onVerseSelected});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: const Color(0xFFFDFBF7),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    if (query.length < 3)
      return const Center(
        child: Text(
          "Search scripture...",
          style: TextStyle(color: Colors.grey),
        ),
      );

    final results = BibleData.searchVerses(query);

    if (results.isEmpty) return const Center(child: Text("No verses found."));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              "${result['book']} ${result['chapter']}:${result['verse']}",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "\"${result['text']}\"",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Serif', height: 1.4),
              ),
            ),
            onTap: () {
              close(context, null);
              onVerseSelected(result['book'], result['chapter']);
            },
          ),
        );
      },
    );
  }
}

// ============================================================================
// 5. PRAYER JOURNAL SCREEN
// ============================================================================
class PrayerJournalScreen extends StatelessWidget {
  final String lang;
  const PrayerJournalScreen({Key? key, required this.lang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entries = [
      {
        'type': 'Request',
        'text': "Please pray for my family's health",
        'date': '1/15',
        'icon': Icons.back_hand_rounded,
      },
      {
        'type': 'Answered',
        'text': "Thank God for healing my mother",
        'date': '1/10',
        'icon': Icons.check_circle_rounded,
      },
      {
        'type': 'Gratitude',
        'text': "Grateful for new opportunities at work",
        'date': '1/5',
        'icon': Icons.favorite_rounded,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('prayer_journal', lang)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (ctx, i) {
          final item = entries[i];
          return SmoothCard(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                item['type'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(item['text'] as String),
              ),
              trailing: Text(
                item['date'] as String,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.edit_rounded),
        label: const Text('Write'),
      ),
    );
  }
}

// ============================================================================
// 6. SAINTS SCREEN
// ============================================================================

class SaintsDevotionalsScreen extends StatelessWidget {
  final String lang;
  const SaintsDevotionalsScreen({Key? key, required this.lang})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    // 1. Fetch the Saint for today from our new DB
    final saint = SaintsDatabase.getSaint(today.month, today.day);

    // Theme references for cleaner code
    final primaryColor = Theme.of(context).primaryColor;
    final isMajor =
        saint.isMajorFeast; // Ensure property name matches your model

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text(AppTranslations.get('saints_devotionals', lang)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- SAINT CARD ---
            SmoothCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon (Verified/Star for Major, Sparkle for Regular)
                    Icon(
                      isMajor
                          ? Icons.verified_rounded
                          : Icons.auto_awesome_rounded,
                      size: 48,
                      color: isMajor ? Colors.amber : primaryColor,
                    ),
                    const SizedBox(height: 16),

                    // "SAINT OF THE DAY" Label
                    Text(
                      AppTranslations.get('saint_of_day', lang).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.grey,
                        letterSpacing: 1.5,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Saint Name
                    Text(
                      saint.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Date Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${today.day} / ${today.month}",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Biography
                    Text(
                      saint.bio,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Prayer Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFBF7), // Parchment color
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.format_quote_rounded,
                            color: Colors.amber,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            saint.prayer,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              color: Colors.black87,
                              fontFamily: 'Serif',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- VIEW ALL BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () {
                  // Future: Navigate to full list
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Full Saint Calendar coming soon!"),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_view_month_rounded),
                label: const Text("View Full Calendar"),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor.withOpacity(0.2)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 7. ROSARY SCREEN
// ============================================================================

// ============================================================================
// 7. ELEGANT ROSARY SCREEN (Timeline Design)
// ============================================================================

class RosaryPrayersScreen extends StatefulWidget {
  final String lang;
  const RosaryPrayersScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<RosaryPrayersScreen> createState() => _RosaryPrayersScreenState();
}

class _RosaryPrayersScreenState extends State<RosaryPrayersScreen> {
  String selectedMystery = 'Joyful';

  // Helper to get theme color based on Mystery
  Color _getMysteryColor(String mystery) {
    switch (mystery) {
      case 'Joyful':
        return const Color(0xFFFFA000); // Gold
      case 'Sorrowful':
        return const Color(0xFFD32F2F); // Red/Crimson
      case 'Glorious':
        return const Color(0xFFFBC02D); // Yellow/Gold
      case 'Luminous':
        return const Color(0xFF0288D1); // Light Blue
      default:
        return Colors.indigo;
    }
  }

  String _getMysteryDays(String mystery) {
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
    final mysteries = RosaryDatabase.mysteries[selectedMystery] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Warm parchment
      body: CustomScrollView(
        slivers: [
          // 1. ELEGANT APP BAR
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: const Color(0xFFFDFBF7),
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16),
              centerTitle: true,
              title: Text(
                AppTranslations.get('rosary_prayers', widget.lang),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      themeColor.withOpacity(0.1),
                      const Color(0xFFFDFBF7),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. MYSTERY SELECTOR (Floating Pills)
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
                      final color = _getMysteryColor(m);

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ChoiceChip(
                          label: Text(
                            AppTranslations.get(m.toLowerCase(), widget.lang),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected:
                              (val) => setState(() => selectedMystery = m),
                          selectedColor: color,
                          backgroundColor: Colors.white,
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

          // 3. HEADER INFO
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
              child: Column(
                children: [
                  Text(
                    "$selectedMystery Mysteries",
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
                      "Prayed on ${_getMysteryDays(selectedMystery)}",
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

          // 4. TIMELINE OF MYSTERIES
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final mystery = mysteries[index];
              final isLast = index == mysteries.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Timeline Line
                    SizedBox(
                      width: 60,
                      child: Column(
                        children: [
                          // Top Line
                          Expanded(
                            child: Container(
                              width: 2,
                              color:
                                  index == 0
                                      ? Colors.transparent
                                      : themeColor.withOpacity(0.3),
                            ),
                          ),
                          // Bead/Number
                          Container(
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
                          // Bottom Line
                          Expanded(
                            child: Container(
                              width: 2,
                              color:
                                  isLast
                                      ? Colors.transparent
                                      : themeColor.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content Card
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 24),
                        child: _buildElegantMysteryCard(mystery, themeColor),
                      ),
                    ),
                  ],
                ),
              );
            }, childCount: mysteries.length),
          ),

          // 5. COMMON PRAYERS SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    "Prayers of the Rosary",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...RosaryDatabase.prayers.entries.map(
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
        color: Colors.white,
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
                  // Scripture Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mystery.scripture,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    mystery.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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

// ============================================================================
// 8. SETTINGS SCREEN
// ============================================================================
class SettingsScreen extends StatelessWidget {
  final String lang;
  final Function(String) onLanguageChange;
  final VoidCallback onThemeToggle;
  final ThemeMode themeMode;

  const SettingsScreen({
    Key? key,
    required this.lang,
    required this.onLanguageChange,
    required this.onThemeToggle,
    required this.themeMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('nav_settings', lang)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context, AppTranslations.get('appearance', lang)),
          SmoothCard(
            child: ListTile(
              leading: const Icon(Icons.dark_mode_rounded),
              title: Text(AppTranslations.get('theme', lang)),
              subtitle: Text(
                themeMode == ThemeMode.light
                    ? AppTranslations.get('light', lang)
                    : AppTranslations.get('dark', lang),
              ),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (_) => onThemeToggle(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildHeader(context, AppTranslations.get('language', lang)),
          ...AppConstants.languages.map(
            (l) => SmoothCard(
              child: RadioListTile<String>(
                value: l.code,
                groupValue: lang,
                onChanged: (val) => onLanguageChange(val!),
                title: Text(l.name),
                secondary: Text(l.flag, style: const TextStyle(fontSize: 24)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

// ============================================================================
// ONBOARDING JOURNEY
// ============================================================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  // 🎨 The 3 Screens Data
  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Walk with God\nin 2026",
      "desc":
          "Your daily companion for the liturgical year. Discover feast days, readings, and the beauty of the Church seasons.",
      "icon": null, // Using image instead of icon for the first screen
      "image": "assets/logo.jpeg",
      "color": const Color(0xFF673AB7), // Deep Purple
      "bg": const Color(0xFFF3E5F5), // Light Purple
    },
    {
      "title": "Daily Prayer\n& Devotion",
      "desc":
          "Deepen your faith with the Holy Rosary, daily saint biographies, and scripture readings right at your fingertips.",
      "icon": Icons.auto_awesome_rounded, // Sparkle/Saint
      "color": const Color(0xFFFFA000), // Gold/Amber
      "bg": const Color(0xFFFFF8E1), // Light Gold
    },
    {
      "title": "Never Miss a\nMoment",
      "desc":
          "Set personal prayer reminders for Morning, Noon, and Night. Keep a journal of your spiritual journey.",
      "icon": Icons.notifications_active_rounded,
      "color": const Color(0xFF009688), // Teal
      "bg": const Color(0xFFE0F2F1), // Light Teal
    },
  ];

  // --- FINISH ONBOARDING LOGIC ---
  Future<void> _finishOnboarding() async {
    // 1. Save that the user has seen the onboarding
    await StorageService.completeOnboarding();

    // 2. Navigate to Main App
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => MainNavigation(
                currentLanguage: 'en',
                onLanguageChange: (val) {},
                onThemeToggle: () {},
                themeMode: ThemeMode.light,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activePage = _pages[_currentIndex];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: activePage['bg'], // 🎨 Background Color Animation
        child: SafeArea(
          child: Column(
            children: [
              // 1. SKIP BUTTON
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _finishOnboarding, // Call function here
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: activePage['color'],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              // 2. ANIMATED PAGE CONTENT
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged:
                      (index) => setState(() => _currentIndex = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Icon/Image Circle
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.elasticOut,
                            height: 250, // Increased size
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (page['color'] as Color).withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child:
                                page['image'] != null
                                    ? ClipOval(
                                      child: Image.asset(
                                        page['image'],
                                        fit:
                                            BoxFit
                                                .cover, // Fills the circle completely
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    )
                                    : Icon(
                                      page['icon'],
                                      size: 80,
                                      color: page['color'],
                                    ),
                          ),
                          const SizedBox(height: 40),

                          // Animated Text
                          Text(
                            page['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: page['color'],
                              height: 1.2,
                              fontFamily: 'Serif',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            page['desc'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 3. BOTTOM CONTROLS
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // DOT INDICATORS
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width:
                              _currentIndex == index
                                  ? 24
                                  : 8, // Active dot expands
                          decoration: BoxDecoration(
                            color:
                                _currentIndex == index
                                    ? activePage['color']
                                    : Colors.black12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // NEXT / GET STARTED BUTTON
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 60,
                      width: _currentIndex == _pages.length - 1 ? 160 : 60,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentIndex == _pages.length - 1) {
                            _finishOnboarding(); // Call function here
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: activePage['color'],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 5,
                        ),
                        child:
                            _currentIndex == _pages.length - 1
                                ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Get Started",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded),
                                  ],
                                )
                                : const Icon(Icons.arrow_forward_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
