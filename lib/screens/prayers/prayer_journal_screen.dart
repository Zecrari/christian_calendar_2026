import 'dart:convert';
import 'package:flutter/material.dart';
import '../../config/translations.dart';
import '../../data/storage_service.dart';

// ─── Model ────────────────────────────────────────────────────────────────────
class PrayerJournalEntry {
  final String id;
  final String type; // 'Request' | 'Answered' | 'Gratitude'
  final String text;
  final DateTime date;
  bool answered;

  PrayerJournalEntry({
    required this.id,
    required this.type,
    required this.text,
    required this.date,
    this.answered = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'text': text,
        'date': date.toIso8601String(),
        'answered': answered,
      };

  factory PrayerJournalEntry.fromJson(Map<String, dynamic> j) =>
      PrayerJournalEntry(
        id: j['id'],
        type: j['type'],
        text: j['text'],
        date: DateTime.parse(j['date']),
        answered: j['answered'] ?? false,
      );
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class PrayerJournalScreen extends StatefulWidget {
  final String lang;
  const PrayerJournalScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<PrayerJournalScreen> createState() => _PrayerJournalScreenState();
}

class _PrayerJournalScreenState extends State<PrayerJournalScreen> {
  static const _key = 'prayer_journal_entries_v2';
  List<PrayerJournalEntry> _entries = [];
  String _filter = 'All';

  static const _typeColors = {
    'Request': Color(0xFF673AB7),
    'Answered': Color(0xFF2E7D32),
    'Gratitude': Color(0xFFE65100),
  };
  static const _typeIcons = {
    'Request': Icons.back_hand_rounded,
    'Answered': Icons.check_circle_rounded,
    'Gratitude': Icons.favorite_rounded,
  };

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    final raw = StorageService.getString(_key);
    if (raw == null || raw.isEmpty) return;
    try {
      final List<dynamic> decoded = json.decode(raw);
      setState(() {
        _entries = decoded.map((e) => PrayerJournalEntry.fromJson(e)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      });
    } catch (_) {}
  }

  Future<void> _saveEntries() async {
    final encoded = json.encode(_entries.map((e) => e.toJson()).toList());
    await StorageService.setString(_key, encoded);
  }

  void _addEntry(String type, String text) {
    final entry = PrayerJournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      text: text,
      date: DateTime.now(),
    );
    setState(() => _entries.insert(0, entry));
    _saveEntries();
  }

  void _deleteEntry(String id) {
    setState(() => _entries.removeWhere((e) => e.id == id));
    _saveEntries();
  }

  void _markAnswered(PrayerJournalEntry entry) {
    setState(() => entry.answered = true);
    _saveEntries();
  }

  List<PrayerJournalEntry> get _filtered {
    if (_filter == 'All') return _entries;
    return _entries.where((e) => e.type == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppTranslations.get('prayer_journal', widget.lang),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () => _showInfo(),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Stats Bar
          _buildStatsBar(isDark, primary),
          // Filter Chips
          _buildFilterRow(theme),
          // Entry List
          Expanded(
            child: _filtered.isEmpty
                ? _buildEmptyState(primary)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) =>
                        _buildEntryCard(_filtered[i], theme),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(),
        icon: const Icon(Icons.edit_rounded),
        label: Text(AppTranslations.get('write', widget.lang)),
      ),
    );
  }

  Widget _buildStatsBar(bool isDark, Color primary) {
    final total = _entries.length;
    final answered = _entries.where((e) => e.answered || e.type == 'Answered').length;
    final requests = _entries.where((e) => e.type == 'Request').length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF673AB7), Color(0xFF512DA8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(AppTranslations.get('total', widget.lang), total.toString(), Icons.auto_stories_rounded),
          _divider(),
          _statItem(AppTranslations.get('requests', widget.lang), requests.toString(), Icons.back_hand_rounded),
          _divider(),
          _statItem(AppTranslations.get('answered_type', widget.lang), answered.toString(), Icons.check_circle_rounded),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) => Column(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 11)),
        ],
      );

  Widget _divider() =>
      Container(height: 40, width: 1, color: Colors.white24);

  Widget _buildFilterRow(ThemeData theme) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: ['All', 'Request', 'Answered', 'Gratitude'].map((f) {
          final selected = _filter == f;
          final color = f == 'All'
              ? theme.colorScheme.primary
              : (_typeColors[f] ?? theme.colorScheme.primary);
          final labelKey = f == 'Answered' ? 'answered_type' : f.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(AppTranslations.get(labelKey, widget.lang),
                  style: TextStyle(
                    color: selected ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  )),
              selected: selected,
              onSelected: (_) => setState(() => _filter = f),
              selectedColor: color,
              checkmarkColor: Colors.white,
              backgroundColor: color.withOpacity(0.1),
              side: BorderSide(color: color.withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEntryCard(PrayerJournalEntry entry, ThemeData theme) {
    final color = _typeColors[entry.type] ?? theme.colorScheme.primary;
    final icon = _typeIcons[entry.type] ?? Icons.edit_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Text(AppTranslations.get(entry.type == 'Answered' ? 'answered_type' : entry.type.toLowerCase(), widget.lang),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 13,
                    )),
                const Spacer(),
                Text(
                  '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              entry.text,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            if (entry.type == 'Request' && !entry.answered) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _markAnswered(entry),
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: Text(AppTranslations.get('mark_answered', widget.lang)),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      backgroundColor:
                          const Color(0xFF2E7D32).withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _confirmDelete(entry),
                    icon:
                        const Icon(Icons.delete_outline_rounded, size: 20),
                    color: Colors.red.shade300,
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => _confirmDelete(entry),
                  icon:
                      const Icon(Icons.delete_outline_rounded, size: 20),
                  color: Colors.red.shade300,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color primary) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.menu_book_rounded,
                  size: 64, color: primary.withOpacity(0.5)),
            ),
            const SizedBox(height: 20),
            Text(
              AppTranslations.get('prayer_journal_empty', widget.lang),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppTranslations.get('write_first_prayer', widget.lang),
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );

  void _showAddDialog() {
    String selectedType = 'Request';
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(AppTranslations.get('new_prayer_entry', widget.lang),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              // Type selector
              Row(
                children: ['Request', 'Answered', 'Gratitude'].map((t) {
                  final col = _typeColors[t]!;
                  final sel = selectedType == t;
                  return Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: OutlinedButton(
                          onPressed: () =>
                              setModalState(() => selectedType = t),
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                sel ? col : col.withOpacity(0.08),
                            foregroundColor:
                                sel ? Colors.white : col,
                            side: BorderSide(color: col),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10),
                          ),
                          child: FittedBox(
                            child: Text(AppTranslations.get(t == 'Answered' ? 'answered_type' : t.toLowerCase(), widget.lang),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: AppTranslations.get('write_prayer_hint', widget.lang),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      _addEntry(
                          selectedType, controller.text.trim());
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.save_rounded),
                  label: Text(AppTranslations.get('save', widget.lang)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(PrayerJournalEntry entry) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppTranslations.get('delete_entry', widget.lang)),
        content: Text(AppTranslations.get('delete_entry_confirm', widget.lang)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppTranslations.get('cancel', widget.lang)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEntry(entry.id);
            },
            child: Text(AppTranslations.get('delete', widget.lang), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppTranslations.get('prayer_journal', widget.lang)),
        content: Text(
          AppTranslations.get('prayer_journal_info', widget.lang),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppTranslations.get('ok', widget.lang)),
          ),
        ],
      ),
    );
  }
}
