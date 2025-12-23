import 'package:flutter/material.dart';
import '../../config/translations.dart';
import '../../data/saints_data.dart';
import '../../widgets/smooth_card.dart';

class SaintsDevotionalsScreen extends StatelessWidget {
  final String lang;
  const SaintsDevotionalsScreen({Key? key, required this.lang})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final saint = SaintsDatabase.getSaint(today.month, today.day, lang);
    final primaryColor = Theme.of(context).colorScheme.primary; // THEME FIX
    final isMajor = saint.isMajorFeast;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // THEME FIX
      appBar: AppBar(
        title: Text(AppTranslations.get('saints_devotionals', lang)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SmoothCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      isMajor
                          ? Icons.verified_rounded
                          : Icons.auto_awesome_rounded,
                      size: 48,
                      color: isMajor ? Colors.amber : primaryColor,
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 24),
                    Text(
                      saint.bio,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
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
          ],
        ),
      ),
    );
  }
}
