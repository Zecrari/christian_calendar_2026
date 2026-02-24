import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../config/constants.dart';
import '../../config/translations.dart';
import '../../data/storage_service.dart';
import '../../widgets/smooth_card.dart';

class SettingsScreen extends StatefulWidget {
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
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedSound = 'sound_1';
  String? _playingSound;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final String _appVersion = "1.0.0";
  
  // Local state for immediate UI feedback
  late String _localLang;
  late ThemeMode _localThemeMode;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _localLang = widget.lang;
    _localThemeMode = widget.themeMode;
    _loadSound();
    
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() => _playingSound = null);
      }
    });
  }

  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync local state when parent updates
    if (oldWidget.lang != widget.lang) {
      _localLang = widget.lang;
    }
    if (oldWidget.themeMode != widget.themeMode) {
      _localThemeMode = widget.themeMode;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadSound() async {
    String saved = await StorageService.loadNotificationSound();
    if (mounted) setState(() => selectedSound = saved);
  }

  Future<void> _playSound(String soundName) async {
    try {
      if (_playingSound == soundName) {
        await _stopSound();
        return;
      }
      await _audioPlayer.stop();
      setState(() => _playingSound = soundName);
      await _audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
      setState(() => _playingSound = null);
    }
  }

  Future<void> _stopSound() async {
    await _audioPlayer.stop();
    if (mounted) setState(() => _playingSound = null);
  }

  Future<void> _changeSound(String newSound) async {
    await _stopSound();
    await StorageService.saveNotificationSound(newSound);
    setState(() => selectedSound = newSound);
    if (mounted) Navigator.pop(context);
  }

  // --- OPTIMIZED LANGUAGE CHANGE ---
  void _handleLanguageChange(String newLang) {
    if (_isProcessing || newLang == _localLang) return;
    
    // Immediate UI feedback
    setState(() {
      _isProcessing = true;
      _localLang = newLang;
    });
    
    // Defer heavy operation to next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLanguageChange(newLang);
      setState(() => _isProcessing = false);
    });
  }

  // --- OPTIMIZED THEME CHANGE ---
  void _handleThemeToggle() {
    if (_isProcessing) return;
    
    // Immediate UI feedback
    setState(() {
      _isProcessing = true;
      _localThemeMode = _localThemeMode == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light;
    });
    
    // Defer heavy operation to next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onThemeToggle();
      setState(() => _isProcessing = false);
    });
  }

  void _showSoundSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            void handlePlay(String sound) {
              _playSound(sound).then((_) => setSheetState(() {}));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppTranslations.get('notification_sound', widget.lang),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...['sound_1', 'sound_2', 'sound_3'].map((sound) {
                    final isSelected = selectedSound == sound;
                    final isPlaying = _playingSound == sound;

                    return ListTile(
                      onTap: () => _changeSound(sound),
                      leading: IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.stop_circle_rounded
                              : Icons.play_circle_fill,
                          color: isPlaying
                              ? Colors.red
                              : Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        onPressed: () => handlePlay(sound),
                      ),
                      title: Text(AppTranslations.get(sound, widget.lang)),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() => _stopSound());
  }

  @override
  Widget build(BuildContext context) {
    // Use local state for immediate feedback, parent state for source of truth
    final isDark = _localThemeMode == ThemeMode.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppTranslations.get('nav_settings', widget.lang)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(AppTranslations.get('appearance', widget.lang)),
          SmoothCard(
            child: ListTile(
              leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              title: Text(AppTranslations.get('theme', widget.lang)),
              subtitle: Text(
                isDark
                    ? AppTranslations.get('dark', widget.lang)
                    : AppTranslations.get('light', widget.lang),
              ),
              trailing: Switch(
                value: isDark,
                onChanged: _isProcessing ? null : (_) => _handleThemeToggle(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(
            AppTranslations.get('notifications', widget.lang),
          ),
          SmoothCard(
            child: ListTile(
              onTap: _showSoundSelectionSheet,
              leading: const Icon(Icons.notifications_active_outlined),
              title: Text(
                AppTranslations.get('notification_sound', widget.lang),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppTranslations.get(selectedSound, widget.lang),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(AppTranslations.get('language', widget.lang)),
          ...AppConstants.languages.map((l) {
            final isSelected = _localLang == l.code;
            return SmoothCard(
              margin: const EdgeInsets.only(bottom: 8),
              child: RadioListTile<String>(
                value: l.code,
                groupValue: _localLang,
                onChanged: _isProcessing ? null : (val) => _handleLanguageChange(val!),
                title: Text(l.name),
                secondary: Text(l.flag, style: const TextStyle(fontSize: 24)),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }).toList(),

          const SizedBox(height: 24),
          _buildSectionHeader("About"),
          SmoothCard(
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text("Version"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _appVersion,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          
          // Loading indicator when processing
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}