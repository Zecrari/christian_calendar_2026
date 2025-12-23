// Auto-generated file
import 'package:flutter/material.dart';
import '../../config/translations.dart';
import '../../widgets/smooth_card.dart';

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
        'text': "Grateful for new opportunities",
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
