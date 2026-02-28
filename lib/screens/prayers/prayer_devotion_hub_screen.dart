import 'package:flutter/material.dart';
import '../../config/translations.dart';
import '../../data/liturgical_calculator.dart';
import '../../data/saints_feast_data.dart';
import '../../data/storage_service.dart';
import 'prayer_reminders_screen.dart';
import 'rosary_screen.dart';
import 'prayer_journal_screen.dart';
import 'novena_screen.dart';
import 'stations_of_cross_screen.dart';
import 'confession_guide_screen.dart';
import 'liturgy_of_hours_screen.dart';

class PrayerDevotionHubScreen extends StatelessWidget {
  final String lang;
  const PrayerDevotionHubScreen({Key? key, required this.lang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final today = DateTime.now();
    final isFasting = LiturgicalCalculator.isFastingDay(today);
    final fastingLabel = LiturgicalCalculator.getFastingLabel(today, lang);
    final baptismName = StorageService.getBaptismName();
    final saintData = baptismName.isNotEmpty
        ? SaintFeastData.findSaintByName(baptismName)
        : null;
    final isFeastToday =
        saintData != null && SaintFeastData.isFeastDayToday(saintData);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.get('rosary_prayers', lang),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: [
          // ── Fasting Alert ────────────────────────────────────────────────
          if (isFasting)
            Container(
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
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_rounded,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      fastingLabel,
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
            ),

          // ── Feast Day Greeting ───────────────────────────────────────────
          if (isFeastToday && saintData != null)
            Container(
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
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      lang == 'ta'
                          ? saintData.greetingTa
                          : lang == 'hi'
                              ? saintData.greetingHi
                              : saintData.greeting,
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
            ),

          // ── Section Header ───────────────────────────────────────────────
          _sectionHeader(context, 'DAILY PRAYER'),

          // ── Prayer Grid ──────────────────────────────────────────────────
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
            children: [
              _buildCard(
                context,
                icon: Icons.wb_sunny_rounded,
                label: 'Morning/Evening Prayer',
                subtitle: 'Liturgy of the Hours',
                gradient: [const Color(0xFFF57C00), const Color(0xFFE65100)],
                destination: LiturgyOfHoursScreen(lang: lang),
              ),
              _buildCard(
                context,
                icon: Icons.volunteer_activism_rounded,
                label: 'Rosary & Prayers',
                subtitle: 'Mysteries & devotions',
                gradient: [const Color(0xFFEC407A), const Color(0xFFC2185B)],
                destination: RosaryPrayersScreen(lang: lang),
              ),
              _buildCard(
                context,
                icon: Icons.notifications_active_rounded,
                label: 'Prayer Reminders',
                subtitle: 'Set daily alerts',
                gradient: [const Color(0xFFFF9800), const Color(0xFFF57C00)],
                destination: PrayerRemindersScreen(lang: lang),
              ),
              _buildCard(
                context,
                icon: Icons.book_rounded,
                label: 'Prayer Journal',
                subtitle: 'Write intentions',
                gradient: [const Color(0xFF5C6BC0), const Color(0xFF3949AB)],
                destination: PrayerJournalScreen(lang: lang),
              ),
            ],
          ),

          const SizedBox(height: 20),
          _sectionHeader(context, 'DEVOTIONS'),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
            children: [
              _buildCard(
                context,
                icon: Icons.local_fire_department_rounded,
                label: 'Daily Novena',
                subtitle: '9-day prayer sets',
                gradient: [const Color(0xFFD32F2F), const Color(0xFFB71C1C)],
                destination: NovenaScreen(lang: lang),
              ),
              _buildCard(
                context,
                icon: Icons.church_rounded,
                label: 'Stations of the Cross',
                subtitle: '14 stations with reflection',
                gradient: [const Color(0xFF5D4037), const Color(0xFF4E342E)],
                destination: StationsOfCrossScreen(lang: lang),
              ),
              _buildCard(
                context,
                icon: Icons.checklist_rounded,
                label: 'Confession Guide',
                subtitle: 'Examination of conscience',
                gradient: [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
                destination: ConfessionGuideScreen(lang: lang),
              ),
              _buildCard(
                context,
                icon: Icons.self_improvement_rounded,
                label: 'Meditation',
                subtitle: 'Coming soon',
                gradient: [Colors.teal.shade600, Colors.teal.shade800],
                destination: null,
                comingSoon: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4, top: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required List<Color> gradient,
    required Widget? destination,
    bool comingSoon = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (comingSoon) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppTranslations.get('coming_soon', lang)),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    comingSoon ? '✨ Coming Soon' : subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
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
}
