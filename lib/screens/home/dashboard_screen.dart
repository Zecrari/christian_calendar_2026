import 'package:christian_calendar/widgets/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/translations.dart';
import '../../config/constants.dart';
import '../../widgets/smooth_card.dart';
import '../../data/bible_data.dart';
import '../../data/storage_service.dart';
import '../../data/liturgical_calculator.dart';
import '../../data/saints_feast_data.dart';
import '../../services/reading_tracker_service.dart';
import '../bible/bible_reader_screen.dart';
import '../calendar/calendar_screen.dart';
import '../calendar/moveable_feasts_screen.dart';
import '../prayers/prayer_reminders_screen.dart';
import '../prayers/prayer_journal_screen.dart';
import '../prayers/prayer_devotion_hub_screen.dart';
import '../prayers/novena_screen.dart';
import '../prayers/stations_of_cross_screen.dart';
import '../prayers/confession_guide_screen.dart';
import '../saints/saints_screen.dart';
import '../tracker/reading_tracker_screen.dart';
import '../bible/buy_bible_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String lang;
  const DashboardScreen({Key? key, required this.lang}) : super(key: key);

  Future<void> _openNearbyChurches(BuildContext context) async {
    final Uri url = Uri.parse(AppConstants.MAPS_SEARCH_QUERY);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication))
        throw Exception('Could not launch maps');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not open Maps: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final verse = DailyVerses.getVerse(today.day, lang);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('app_title', lang)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. Welcome Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF673AB7), Color(0xFF512DA8)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppTranslations.get('greeting', lang),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDate(today),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Fasting Day Alert
          _buildFastingAlertCard(),

          // Personal Feast Day Alert
          _buildFeastDayCard(),

          // 2. NEW: Bible Reading Tracker Card (Main Feature)
          _buildReadingTrackerCard(context),
          const SizedBox(height: 24),

          // 3. Verse of the Day
          _buildSectionTitle(
            context,
            AppTranslations.get('verse_of_day', lang),
          ),
          SmoothCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${verse['text']}"',
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      verse['reference']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 4. Quick Actions Grid
          _buildSectionTitle(
            context,
            AppTranslations.get('quick_actions', lang),
          ),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
            children: [
              _buildQuickAction(
                context,
                Icons.notifications_active_rounded,
                AppTranslations.get('nav_reminders', lang),
                Colors.orange,
                destination: PrayerRemindersScreen(lang: lang),
              ),
              _buildQuickAction(
                context,
                Icons.face_rounded,
                AppTranslations.get('nav_saints', lang),
                Colors.blueGrey,
                destination: SaintsDevotionalsScreen(lang: lang),
              ),
              _buildQuickAction(
                context,
                Icons.volunteer_activism_rounded,
                AppTranslations.get('nav_rosary', lang),
                Colors.pink,
                destination: PrayerDevotionHubScreen(lang: lang),
              ),
              _buildQuickAction(
                context,
                Icons.local_fire_department_rounded,
                AppTranslations.get('novena', lang),
                Colors.red,
                destination: NovenaScreen(lang: lang),
              ),
              _buildQuickAction(
                context,
                Icons.church_rounded,
                AppTranslations.get('stations_cross', lang),
                const Color(0xFF5D4037),
                destination: StationsOfCrossScreen(lang: lang),
              ),
              _buildQuickAction(
                context,
                Icons.grid_view_rounded,
                AppTranslations.get('more_options', lang),
                Theme.of(context).colorScheme.primary,
                onTap: () => _showMoreOptionsBottomSheet(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- READING TRACKER DASHBOARD CARD ---
  Widget _buildReadingTrackerCard(BuildContext context) {
    final int currentStreak = StorageService.getCurrentStreak();
    final int longestStreak = StorageService.getLongestStreak();
    final double completionPercent = ReadingTrackerService.getBibleCompletionPercentage();
    final bool readToday = ReadingTrackerService.hasReadToday();
    final int chaptersRead = StorageService.getReadChapters().length;
    final String currentBook = StorageService.getCurrentBook();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReadingTrackerScreen(lang: lang),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: readToday
                ? [const Color(0xFF4CAF50), const Color(0xFF2E7D32)]
                : [const Color(0xFFFF6B35), const Color(0xFFF7931E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (readToday ? Colors.green : Colors.orange).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.get('reading_streak', lang),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$currentStreak ${AppTranslations.get('days', lang)}',
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          readToday ? Icons.check_circle : Icons.circle_outlined,
                          color: readToday ? Colors.green : Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          readToday 
                              ? AppTranslations.get('completed', lang)
                              : AppTranslations.get('read_now', lang),
                          style: TextStyle(
                            color: readToday ? Colors.green.shade700 : Colors.orange.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completionPercent / 100,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$chaptersRead ${AppTranslations.get('chapters_read', lang)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${completionPercent.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFastingAlertCard() {
    final today = DateTime.now();
    final isFasting = LiturgicalCalculator.isFastingDay(today);
    if (!isFasting) return const SizedBox.shrink();
    final label = LiturgicalCalculator.getFastingLabel(today, lang);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF673AB7), Color(0xFF512DA8)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.no_food_rounded, color: Colors.white, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeastDayCard() {
    final baptismName = StorageService.getBaptismName();
    if (baptismName.isEmpty) return const SizedBox.shrink();
    final saint = SaintFeastData.findSaintByName(baptismName);
    if (saint == null) return const SizedBox.shrink();
    final isToday = SaintFeastData.isFeastDayToday(saint);
    if (!isToday) return const SizedBox.shrink();
    final greeting = saint.greeting;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFA000), Color(0xFFFF6F00)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              greeting,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color, {
    Widget? destination,
    VoidCallback? onTap,
  }) {
    return SmoothCard(
      onTap: () {
        if (onTap != null)
          onTap();
        else if (destination != null)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, height: 1.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showMoreOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                AppTranslations.get('more_options', lang),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  _buildQuickAction(
                    context,
                    Icons.library_books_rounded,
                    AppTranslations.get('nav_journal', lang),
                    Colors.deepPurple,
                    destination: PrayerJournalScreen(lang: lang),
                  ),
                  _buildQuickAction(
                    context,
                    Icons.church_rounded,
                    AppTranslations.get('churches_nearby', lang),
                    Colors.teal,
                    onTap: () {
                      Navigator.pop(context);
                      _openNearbyChurches(context);
                    },
                  ),
                  _buildQuickAction(
                    context,
                    Icons.checklist_rounded,
                    AppTranslations.get('confession_guide', lang),
                    Colors.indigo,
                    destination: ConfessionGuideScreen(lang: lang),
                  ),
                  _buildQuickAction(
                    context,
                    Icons.calendar_month_rounded,
                    AppTranslations.get('moveable_feasts', lang),
                    const Color(0xFFFFA000),
                    destination: MoveableFeastsScreen(lang: lang),
                  ),
                  _buildQuickAction(
                    context,
                    Icons.shopping_bag_rounded,
                    AppTranslations.get('buy_a_bible', lang),
                    const Color(0xFF7B1FA2),
                    destination: BuyBibleScreen(lang: lang),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) =>
      '${AppTranslations.getMonth(date.month, lang)} ${date.day}, ${date.year}';
}