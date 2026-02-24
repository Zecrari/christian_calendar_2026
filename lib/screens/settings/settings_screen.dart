import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/constants.dart';
import '../../config/translations.dart';
import '../../data/storage_service.dart';
import '../bible/buy_bible_screen.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();
  final String _appVersion = "1.0.0";
  
  String selectedSound = 'sound_1';
  String? _playingSound;
  
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
      if (mounted) setState(() => _playingSound = null);
    });
  }

  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lang != widget.lang) _localLang = widget.lang;
    if (oldWidget.themeMode != widget.themeMode) _localThemeMode = widget.themeMode;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // ─── LOGIC & HANDLERS ──────────────────────────────────────────────────────

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
      debugPrint("Error playing sound: $e");
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

  void _handleLanguageChange(String newLang) {
    if (_isProcessing || newLang == _localLang) return;
    setState(() {
      _isProcessing = true;
      _localLang = newLang;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLanguageChange(newLang);
      setState(() => _isProcessing = false);
    });
  }

  void _handleThemeToggle() {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
      _localThemeMode = _localThemeMode == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onThemeToggle();
      setState(() => _isProcessing = false);
    });
  }

  Future<void> _launchFeedback() async {
    final uri = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSeDZ6uAlyc_PwBSzFWwGVV_IAjzhV62awFDNbfCf-uxVyh2vw/viewform');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open feedback form')),
        );
      }
    }
  }

  void _showSoundSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _SoundSelectionSheet(
        lang: widget.lang,
        selectedSound: selectedSound,
        playingSound: _playingSound,
        onPlay: _playSound,
        onSelect: _changeSound,
      ),
    ).whenComplete(() => _stopSound());
  }

  // ─── UI BUILDER ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = _localThemeMode == ThemeMode.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppTranslations.get('nav_settings', widget.lang)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              // 1. LANGUAGE GROUP
              _SectionHeader(title: AppTranslations.get('language', widget.lang)),
              _SettingsCard(
                children: AppConstants.languages.map((l) {
                  return RadioListTile<String>(
                    value: l.code,
                    groupValue: _localLang,
                    onChanged: _isProcessing ? null : (val) => _handleLanguageChange(val!),
                    title: Text(l.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    secondary: Text(l.flag, style: const TextStyle(fontSize: 22)),
                    activeColor: primaryColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // 2. PREFERENCES GROUP (Theme & Notifications combined)
              _SectionHeader(title: AppTranslations.get('appearance', widget.lang)),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    leadingIcon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    iconColor: isDark ? Colors.amber : Colors.orange,
                    title: AppTranslations.get('theme', widget.lang),
                    subtitle: AppTranslations.get(isDark ? 'dark' : 'light', widget.lang),
                    trailing: Switch(
                      value: isDark,
                      onChanged: _isProcessing ? null : (_) => _handleThemeToggle(),
                      activeColor: primaryColor,
                    ),
                  ),
                  _SettingsTile(
                    onTap: _showSoundSelectionSheet,
                    leadingIcon: Icons.notifications_active_rounded,
                    iconColor: Colors.redAccent,
                    title: AppTranslations.get('notification_sound', widget.lang),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppTranslations.get(selectedSound, widget.lang),
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 3. EXPLORE / SUPPORT GROUP
              _SectionHeader(title: AppTranslations.get('shop', widget.lang)),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BuyBibleScreen(lang: widget.lang)),
                    ),
                    leadingIcon: Icons.shopping_bag_rounded,
                    iconColor: const Color(0xFF7B1FA2),
                    title: AppTranslations.get('buy_a_bible', widget.lang),
                    subtitle: AppTranslations.get('browse_bibles_amazon', widget.lang),
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  ),
                  _SettingsTile(
                    onTap: _launchFeedback,
                    leadingIcon: Icons.rate_review_rounded,
                    iconColor: const Color(0xFF1976D2),
                    title: AppTranslations.get('feedback', widget.lang),
                    subtitle: AppTranslations.get('feedback_subtitle', widget.lang),
                    trailing: const Icon(Icons.open_in_new_rounded, color: Colors.grey, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 4. ABOUT GROUP
              _SectionHeader(title: "About"),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    leadingIcon: Icons.info_outline_rounded,
                    iconColor: Colors.grey.shade600,
                    title: "Version",
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _appVersion,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),

          // LOADING OVERLAY
          if (_isProcessing)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

// ─── ELEGANT REUSABLE WIDGETS ────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

// THIS REPLACES THE SmoothCard IMPORT
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Inject dividers automatically between items
    List<Widget> separatedChildren = [];
    for (int i = 0; i < children.length; i++) {
      separatedChildren.add(children[i]);
      if (i < children.length - 1) {
        separatedChildren.add(
          Divider(height: 1, thickness: 1, indent: 64, color: Colors.grey.withOpacity(isDark ? 0.2 : 0.1)),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.transparent,
          width: 1,
        ),
      ),
      // ClipRRect ensures that the tap ripples from the ListTiles don't bleed out of the rounded corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: separatedChildren,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData leadingIcon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.leadingIcon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(leadingIcon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(fontSize: 13)) : null,
      trailing: trailing,
    );
  }
}

class _SoundSelectionSheet extends StatelessWidget {
  final String lang;
  final String selectedSound;
  final String? playingSound;
  final Function(String) onPlay;
  final Function(String) onSelect;

  const _SoundSelectionSheet({
    required this.lang,
    required this.selectedSound,
    required this.playingSound,
    required this.onPlay,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppTranslations.get('notification_sound', lang),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...['sound_1', 'sound_2', 'sound_3'].map((sound) {
            final isSelected = selectedSound == sound;
            final isPlaying = playingSound == sound;

            return ListTile(
              onTap: () => onSelect(sound),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: IconButton(
                icon: Icon(
                  isPlaying ? Icons.stop_circle_rounded : Icons.play_circle_fill,
                  color: isPlaying ? Colors.red : primaryColor,
                  size: 32,
                ),
                onPressed: () => onPlay(sound),
              ),
              title: Text(AppTranslations.get(sound, lang), style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Colors.green) : null,
            );
          }).toList(),
        ],
      ),
    );
  }
}