import 'package:flutter/material.dart';

import '../../config/translations.dart';
import '../../widgets/banner_ad_widget.dart';
import '../../data/stations_data.dart';

class StationsOfCrossScreen extends StatefulWidget {
  final String lang;
  const StationsOfCrossScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<StationsOfCrossScreen> createState() => _StationsOfCrossScreenState();
}

class _StationsOfCrossScreenState extends State<StationsOfCrossScreen> {
  int _currentStation = 0;
  final PageController _pageController = PageController();

  static const _accentColor = Color(0xFFD32F2F);

  late List<Map<String, dynamic>> _stations;

  @override
  void initState() {
    super.initState();
    _stations = StationsData.getStations(widget.lang);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // App Bar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _accentColor.withOpacity(0.9),
                  _accentColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Stations of the Cross',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Text(
                  '${_currentStation + 1}/14',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Progress
          LinearProgressIndicator(
            value: (_currentStation + 1) / 14,
            backgroundColor: _accentColor.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(_accentColor),
            minHeight: 4,
          ),

          // Station Dots
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 14,
              itemBuilder: (ctx, i) {
                final isCurrent = i == _currentStation;
                return GestureDetector(
                  onTap: () {
                    setState(() => _currentStation = i);
                    _pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isCurrent ? 28 : 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? _accentColor
                          : _accentColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                );
              },
            ),
          ),

          // Page View
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentStation = i),
              itemCount: 14,
              itemBuilder: (ctx, index) =>
                  _buildStationPage(_stations[index], theme),
            ),
          ),

          // Navigation
          _buildNavigation(theme),
        ],
      ),
      bottomNavigationBar: const MyBannerAdWidget(),
    );
  }

  Widget _buildStationPage(Map<String, dynamic> station, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          // Station Number Badge
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_accentColor, Color(0xFFB71C1C)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _accentColor.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${station['num']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            station['title'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              station['scripture'] as String,
              style: const TextStyle(
                  color: _accentColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),

          // Reflection Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_stories_rounded,
                          color: Colors.blue, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(AppTranslations.get('reflection', widget.lang),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  station['reflection'] as String,
                  style: const TextStyle(fontSize: 15, height: 1.65),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Prayer Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _accentColor.withOpacity(0.08),
                  _accentColor.withOpacity(0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accentColor.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.volunteer_activism_rounded,
                          color: _accentColor, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(AppTranslations.get('prayer', widget.lang),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: _accentColor)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  station['prayer'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Response
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _accentColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              AppTranslations.get('we_adore_you', widget.lang),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavigation(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStation > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text('${AppTranslations.get('station', widget.lang)} $_currentStation'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _accentColor,
                  side: const BorderSide(color: _accentColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          if (_currentStation > 0 && _currentStation < 13)
            const SizedBox(width: 12),
          if (_currentStation < 13)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text('${AppTranslations.get('station', widget.lang)} ${_currentStation + 2}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          if (_currentStation == 13)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_circle_rounded),
                label: Text(AppTranslations.get('completed_cross', widget.lang)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
