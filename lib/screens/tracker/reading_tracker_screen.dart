import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/translations.dart';
import '../../data/storage_service.dart';
import '../../services/reading_tracker_service.dart';
import '../bible/bible_reader_screen.dart';

class ReadingTrackerScreen extends StatefulWidget {
  final String lang;
  const ReadingTrackerScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<ReadingTrackerScreen> createState() => _ReadingTrackerScreenState();
}

class _ReadingTrackerScreenState extends State<ReadingTrackerScreen> {
  int currentStreak = 0;
  int longestStreak = 0;
  int totalChaptersRead = 0;
  int totalPagesRead = 0;
  bool hasReadToday = false;
  double bibleProgress = 0.0;
  List<bool> last7Days = [];
  String currentBook = 'Genesis';
  int currentChapter = 1;
  List<String> achievements = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      currentStreak = StorageService.getCurrentStreak();
      longestStreak = StorageService.getLongestStreak();
      totalChaptersRead = StorageService.getReadChapters().length;
      totalPagesRead = StorageService.getTotalPagesRead();
      hasReadToday = ReadingTrackerService.hasReadToday();
      bibleProgress = ReadingTrackerService.getBibleCompletionPercentage();
      last7Days = ReadingTrackerService.getLast7DaysActivity();
      currentBook = StorageService.getCurrentBook();
      currentChapter = StorageService.getCurrentChapter();
      achievements = StorageService.getAchievements();
    });
  }

  Future<void> _markAsRead() async {
    HapticFeedback.mediumImpact();
    
    final result = await ReadingTrackerService.recordReading(
      book: currentBook,
      chapter: currentChapter,
    );

    _loadData();

    if (result['earnedAchievement'] == true) {
      _showAchievementDialog(result['achievementName']);
    }
  }

  void _showAchievementDialog(String? achievement) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              AppTranslations.get('achievement_unlocked', widget.lang),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              achievement ?? '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppTranslations.get('awesome', widget.lang)),
          ),
        ],
      ),
    );
  }

  // Helper to safely convert double to int
  int _safeToInt(double value) {
    if (value.isNaN || value.isInfinite) return 0;
    return value.toInt();
  }

  // Helper to safely format percentage
  String _safePercent(double value) {
    if (value.isNaN || value.isInfinite) return '0';
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppTranslations.get('reading_tracker', widget.lang),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStreakCard(),
                  const SizedBox(height: 16),
                  _buildWeeklyCard(),
                  const SizedBox(height: 16),
                  _buildProgressCard(),
                  const SizedBox(height: 16),
                  _buildStatsGrid(),
                  const SizedBox(height: 16),
                  _buildAchievementsCard(),
                  const SizedBox(height: 24),
                  _buildContinueButton(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasReadToday
              ? [const Color(0xFF4CAF50), const Color(0xFF2E7D32)]
              : [const Color(0xFFFF6B35), const Color(0xFFF7931E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (hasReadToday ? Colors.green : Colors.orange).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslations.get('current_streak', widget.lang),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 36,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$currentStreak',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppTranslations.get('days', widget.lang),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.white, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        AppTranslations.get('best', widget.lang),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '$longestStreak',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (!hasReadToday)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _markAsRead,
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(
                    AppTranslations.get('mark_read_today', widget.lang),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF6B35),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      AppTranslations.get('completed_today', widget.lang),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

  Widget _buildWeeklyCard() {
    final days = widget.lang == 'ta' 
        ? ['தி', 'செ', 'பு', 'வி', 'வெ', 'ச', 'ஞா']
        : ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppTranslations.get('last_7_days', widget.lang),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${last7Days.where((e) => e).length}/7',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final isActive = last7Days.length > index ? last7Days[index] : false;
                final isToday = index == 6;
                
                return Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : isToday
                                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                : Colors.grey.shade200,
                        shape: BoxShape.circle,
                        border: isToday && !isActive
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : null,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isActive ? Icons.local_fire_department : Icons.circle,
                        color: isActive
                            ? Colors.white
                            : isToday
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade400,
                        size: isActive ? 24 : 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      days[index],
                      style: TextStyle(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade500,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    // Safe progress value
    final safeProgress = bibleProgress.isNaN || bibleProgress.isInfinite ? 0.0 : bibleProgress;
    final progressValue = (safeProgress / 100).clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTranslations.get('bible_progress', widget.lang),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: progressValue,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${_safePercent(safeProgress)}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppTranslations.get('complete', widget.lang),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: _buildTestamentProgress(
                    AppTranslations.get('old_testament', widget.lang),
                    0.25,
                    const Color(0xFF673AB7),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTestamentProgress(
                    AppTranslations.get('new_testament', widget.lang),
                    0.15,
                    const Color(0xFFFFA000),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestamentProgress(String label, double progress, Color color) {
    // Safe progress
    final safeProgress = progress.isNaN || progress.isInfinite ? 0.0 : progress.clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: safeProgress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_safeToInt(safeProgress * 100)}%',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    // Calculate safe consistency percentage
    double consistencyPercent = 0.0;
    if (longestStreak > 0) {
      consistencyPercent = (currentStreak / longestStreak) * 100;
    }
    if (consistencyPercent.isNaN || consistencyPercent.isInfinite) {
      consistencyPercent = 0.0;
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          Icons.menu_book_rounded,
          '$totalChaptersRead',
          AppTranslations.get('chapters_read', widget.lang),
          const Color(0xFF673AB7),
        ),
        _buildStatCard(
          Icons.schedule_rounded,
          '${(totalPagesRead * 2 / 60).toStringAsFixed(1)}',
          AppTranslations.get('hours_total', widget.lang),
          const Color(0xFF2196F3),
        ),
        _buildStatCard(
          Icons.bookmark_rounded,
          currentBook,
          AppTranslations.get('current_book', widget.lang),
          const Color(0xFF4CAF50),
        ),
        _buildStatCard(
          Icons.trending_up_rounded,
          '${_safeToInt(consistencyPercent)}%',
          AppTranslations.get('consistency', widget.lang),
          const Color(0xFFFF9800),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard() {
    final allAchievements = [
      {'id': 'first_step', 'name': 'First Step', 'icon': Icons.directions_walk},
      {'id': 'week_warrior', 'name': 'Week Warrior', 'icon': Icons.local_fire_department},
      {'id': 'month_master', 'name': 'Month Master', 'icon': Icons.emoji_events},
      {'id': 'genesis_complete', 'name': 'Genesis Complete', 'icon': Icons.book},
      {'id': 'psalm_reader', 'name': 'Psalm Reader', 'icon': Icons.music_note},
      {'id': 'gospel_reader', 'name': 'Gospel Reader', 'icon': Icons.favorite},
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppTranslations.get('achievements', widget.lang),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${achievements.length}/${allAchievements.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: allAchievements.map((achievement) {
                final isUnlocked = achievements.contains(achievement['id']);
                
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: isUnlocked
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        achievement['icon'] as IconData,
                        size: 18,
                        color: isUnlocked
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        achievement['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.normal,
                          color: isUnlocked
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade500,
                        ),
                      ),
                      if (isUnlocked) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle, size: 14, color: Colors.green),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BibleReaderScreen(lang: widget.lang),
            ),
          ).then((_) => _loadData());
        },
        icon: const Icon(Icons.play_arrow_rounded),
        label: Text(
          AppTranslations.get('continue_reading', widget.lang),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        ),
      ),
    );
  }
}