import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../config/translations.dart';
import '../../widgets/banner_ad_widget.dart';
import '../../data/models.dart';
import '../../data/storage_service.dart';
import '../../data/bible_data.dart';

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

  @override
  void didUpdateWidget(PrayerRemindersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lang != widget.lang) {
      _loadData();
    }
  }

  // --- 1. DATA LOADING ---
  Future<void> _loadData() async {
    final saved = await StorageService.loadReminders();

    if (saved.isNotEmpty) {
      // Sync names with current language based on Icon ID
      List<PrayerReminder> syncedReminders =
          saved.map((r) {
            if (r.iconCode == Icons.wb_sunny_rounded.codePoint) {
              return _copyWithName(
                r,
                AppTranslations.get('morning_prayer', widget.lang),
              );
            } else if (r.iconCode == Icons.wb_sunny_outlined.codePoint) {
              return _copyWithName(
                r,
                AppTranslations.get('noon_prayer', widget.lang),
              );
            } else if (r.iconCode == Icons.bedtime_rounded.codePoint) {
              return _copyWithName(
                r,
                AppTranslations.get('night_prayer', widget.lang),
              );
            }
            return r;
          }).toList();

      setState(() {
        reminders = syncedReminders;
        isLoading = false;
      });
    } else {
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

  PrayerReminder _copyWithName(PrayerReminder original, String newName) {
    return PrayerReminder(
      name: newName,
      time: original.time,
      enabled: original.enabled,
      iconCode: original.iconCode,
      colorValue: original.colorValue,
      frequency: original.frequency,
    );
  }

  Future<void> _saveData() async {
    await StorageService.saveReminders(reminders);
  }

  // --- 2. NOTIFICATION SETUP ---
  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('notification_icon');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    await _notificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    final platform =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await platform?.requestNotificationsPermission();
    await platform?.requestExactAlarmsPermission();
  }

  Future<void> _scheduleNotification(int id, PrayerReminder reminder) async {
    final today = DateTime.now();
    final verse = DailyVerses.getVerse(today.day + id, widget.lang);
    final String bodyText = "${verse['text']} - ${verse['reference']}";

    String soundName = await StorageService.loadNotificationSound();
    String channelId = 'prayer_channel_$soundName';

    DateTimeComponents? matchComponent;
    if (reminder.frequency == 'Daily') matchComponent = DateTimeComponents.time;
    if (reminder.frequency == 'Weekly') {
      matchComponent = DateTimeComponents.dayOfWeekAndTime;
    }
    if (reminder.frequency == 'Monthly') {
      matchComponent = DateTimeComponents.dayOfMonthAndTime;
    }

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

    await _notificationsPlugin.zonedSchedule(
      id,
      "🙏 ${reminder.name}",
      bodyText,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Prayer Reminders ($soundName)',
          channelDescription: 'Daily prayer alerts',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound(soundName),
          playSound: true,
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails(sound: '$soundName.mp3'),
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

  // --- 3. HELPER FOR ICONS (FIXES BUILD ERROR) ---
  IconData _getIconFromCode(int codePoint) {
    // Explicitly mapping icons prevents "Tree Shaking" errors during release build
    if (codePoint == Icons.wb_sunny_rounded.codePoint)
      return Icons.wb_sunny_rounded;
    if (codePoint == Icons.wb_sunny_outlined.codePoint)
      return Icons.wb_sunny_outlined;
    if (codePoint == Icons.bedtime_rounded.codePoint)
      return Icons.bedtime_rounded;
    if (codePoint == Icons.star_rounded.codePoint) return Icons.star_rounded;

    // Fallback to a constant icon to prevent tree-shaking errors
    return Icons.notifications;
  }

  // --- 4. UI: ADD/EDIT SHEET ---
  void _addOrEditReminder({PrayerReminder? existing, int? index}) async {
    TimeOfDay selectedTime = existing?.time ?? TimeOfDay.now();
    String selectedFreq = existing?.frequency ?? 'Daily';
    TextEditingController nameController = TextEditingController(
      text:
          existing?.name ?? AppTranslations.get('morning_prayer', widget.lang),
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => StatefulBuilder(
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
                    Text(
                      AppTranslations.get('set_reminder', widget.lang),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: AppTranslations.get(
                          'prayer_name',
                          widget.lang,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            if (t != null) {
                              setSheetState(() => selectedTime = t);
                            }
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
                    DropdownButtonFormField<String>(
                      value: selectedFreq,
                      decoration: InputDecoration(
                        labelText: AppTranslations.get('repeat', widget.lang),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items:
                          ['Daily', 'Weekly', 'Monthly'].map((f) {
                            String label = f;
                            if (f == 'Daily')
                              label = AppTranslations.get('daily', widget.lang);
                            if (f == 'Weekly')
                              label = AppTranslations.get(
                                'weekly',
                                widget.lang,
                              );
                            if (f == 'Monthly')
                              label = AppTranslations.get(
                                'monthly',
                                widget.lang,
                              );
                            return DropdownMenuItem(
                              value: f,
                              child: Text(label),
                            );
                          }).toList(),
                      onChanged:
                          (val) => setSheetState(() => selectedFreq = val!),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          final newReminder = PrayerReminder(
                            name: nameController.text,
                            time: selectedTime,
                            enabled: true,
                            iconCode: Icons.star_rounded.codePoint,
                            colorValue: Colors.blue.value,
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
                        child: Text(AppTranslations.get('save', widget.lang)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  // --- 5. BUILD UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      bottomNavigationBar: const MyBannerAdWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditReminder(),
        icon: const Icon(Icons.add_alarm_rounded),
        label: Text(AppTranslations.get('add', widget.lang)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildElegantReminderCard(int index, PrayerReminder reminder) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
                    // FIXED: Use helper method instead of dynamic IconData
                    _getIconFromCode(reminder.iconCode),
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
                        "${reminder.name}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
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
                    if (val) {
                      _scheduleNotification(index, reminders[index]);
                    } else {
                      _cancelNotification(index);
                    }
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
