// Auto-generated file
import 'package:flutter/material.dart';
import '../../data/storage_service.dart';
import '../home/main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Walk with God\nin 2026",
      "desc": "Your daily companion for the liturgical year...",
      "image": "assets/logo.jpeg",
      "color": const Color(0xFF673AB7),
      "bg": const Color(0xFFF3E5F5),
    },
    {
      "title": "Daily Prayer",
      "desc": "Deepen your faith with the Holy Rosary...",
      "icon": Icons.auto_awesome_rounded,
      "color": const Color(0xFFFFA000),
      "bg": const Color(0xFFFFF8E1),
    },
    {
      "title": "Never Miss a Moment",
      "desc": "Set personal prayer reminders...",
      "icon": Icons.notifications_active_rounded,
      "color": const Color(0xFF009688),
      "bg": const Color(0xFFE0F2F1),
    },
  ];

  Future<void> _finishOnboarding() async {
    await StorageService.completeOnboarding();
    if (mounted)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => MainNavigation(
                currentLanguage: 'en',
                onLanguageChange: (val) {},
                onThemeToggle: () {},
                themeMode: ThemeMode.light,
              ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final activePage = _pages[_currentIndex];
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: activePage['bg'],
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: activePage['color'],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged:
                      (index) => setState(() => _currentIndex = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.elasticOut,
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (page['color'] as Color).withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child:
                                page['image'] != null
                                    ? ClipOval(
                                      child: Image.asset(
                                        page['image'],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    )
                                    : Icon(
                                      page['icon'],
                                      size: 80,
                                      color: page['color'],
                                    ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            page['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: page['color'],
                              height: 1.2,
                              fontFamily: 'Serif',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            page['desc'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: _currentIndex == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color:
                                _currentIndex == index
                                    ? activePage['color']
                                    : Colors.black12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 60,
                      width: _currentIndex == _pages.length - 1 ? 160 : 60,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentIndex == _pages.length - 1) {
                            _finishOnboarding();
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: activePage['color'],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 5,
                        ),
                        child:
                            _currentIndex == _pages.length - 1
                                ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Get Started",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded),
                                  ],
                                )
                                : const Icon(Icons.arrow_forward_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
