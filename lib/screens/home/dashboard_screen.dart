import 'package:christian_calendar/widgets/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/translations.dart';
import '../../config/constants.dart';
import '../../widgets/smooth_card.dart';
import '../../data/bible_data.dart';
import '../bible/bible_reader_screen.dart';
import '../calendar/calendar_screen.dart';
import '../prayers/prayer_reminders_screen.dart';
import '../prayers/prayer_journal_screen.dart';
import '../prayers/rosary_screen.dart';
import '../saints/saints_screen.dart';

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
        title: const Text('Christian Calendar 2026'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. Welcome Card (Keep gradient as generic brand colors)
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

          // 2. Verse
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

          // 3. Grid
          _buildSectionTitle(
            context,
            AppTranslations.get('quick_actions', lang),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
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
                Icons.church_rounded,
                AppTranslations.get('churches_nearby', lang),
                Colors.teal,
                onTap: () => _openNearbyChurches(context),
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
                destination: RosaryPrayersScreen(lang: lang),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: MyBannerAdWidget(), // <--- PLACEMENT
        ),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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

  String _formatDate(DateTime date) =>
      '${AppTranslations.getMonth(date.month, lang)} ${date.day}, ${date.year}';
}
