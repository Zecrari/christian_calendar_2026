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
  String? _playingSound; // Tracks which sound is currently playing
  final AudioPlayer _audioPlayer = AudioPlayer();
  final String _appVersion = "1.0.0";

  @override
  void initState() {
    super.initState();
    _loadSound();

    // Listen for when audio finishes to reset the icon
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _playingSound = null;
        });
      }
    });
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

  // --- AUDIO LOGIC ---
  Future<void> _playSound(String soundName) async {
    try {
      // If the clicked sound is already playing, stop it (Toggle behavior)
      if (_playingSound == soundName) {
        await _stopSound();
        return;
      }

      // Otherwise, play the new sound
      await _audioPlayer.stop(); // Stop any previous sound

      setState(() => _playingSound = soundName); // Update UI to show Stop icon

      await _audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
      setState(() => _playingSound = null);
    }
  }

  Future<void> _stopSound() async {
    await _audioPlayer.stop();
    if (mounted) {
      setState(() => _playingSound = null);
    }
  }

  Future<void> _changeSound(String newSound) async {
    await _stopSound(); // Stop playing when selected
    await StorageService.saveNotificationSound(newSound);
    setState(() => selectedSound = newSound);
    if (mounted) Navigator.pop(context);
  }

  // --- POPUP SHEET ---
  void _showSoundSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        // Use StatefulBuilder to update icons inside the sheet
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            // Helper to handle play/stop inside sheet and update sheet state
            void handlePlay(String sound) {
              _playSound(sound).then((_) {
                // Force sheet to rebuild to show new icon
                setSheetState(() {});
              });
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
                      // Play/Stop Button
                      leading: IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.stop_circle_rounded
                              : Icons.play_circle_fill,
                          color:
                              isPlaying
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        onPressed: () => handlePlay(sound),
                      ),
                      title: Text(AppTranslations.get(sound, widget.lang)),
                      trailing:
                          isSelected
                              ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                              : null,
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _stopSound(); // Stop sound when sheet closes
    });
  }

  @override
  Widget build(BuildContext context) {
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
              leading: const Icon(Icons.dark_mode_outlined),
              title: Text(AppTranslations.get('theme', widget.lang)),
              subtitle: Text(
                widget.themeMode == ThemeMode.light
                    ? AppTranslations.get('light', widget.lang)
                    : AppTranslations.get('dark', widget.lang),
              ),
              trailing: Switch(
                value: widget.themeMode == ThemeMode.dark,
                onChanged: (_) => widget.onThemeToggle(),
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
          ...AppConstants.languages.map(
            (l) => SmoothCard(
              child: RadioListTile<String>(
                value: l.code,
                groupValue: widget.lang,
                onChanged: (val) => widget.onLanguageChange(val!),
                title: Text(l.name),
                secondary: Text(l.flag, style: const TextStyle(fontSize: 24)),
              ),
            ),
          ),

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
