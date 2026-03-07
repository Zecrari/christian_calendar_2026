import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAdWidget extends StatefulWidget {
  const MyBannerAdWidget({Key? key}) : super(key: key);

  @override
  State<MyBannerAdWidget> createState() => _MyBannerAdWidgetState();
}

class _MyBannerAdWidgetState extends State<MyBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;

  // ✅ Uses Google's official test ID in debug, real ID in release
  static String get _adUnitId => kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111' // Google test banner
      : 'ca-app-pub-5100408620740144/5238403550'; // Production banner

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadAd();
    });
  }

  void _loadAd() {
    if (_isLoading || _isLoaded) return;
    _isLoading = true;

    final BannerAd banner = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('✅ Banner ad loaded (${kDebugMode ? "TEST" : "PROD"})');
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _isLoading = false;
            });
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('❌ Banner failed: ${error.code} - ${error.message}');
          ad.dispose();
          _bannerAd = null;
          _isLoading = false;
          // Retry after 60 seconds
          Future.delayed(const Duration(seconds: 60), () {
            if (mounted) _loadAd();
          });
        },
      ),
    );

    banner.load();
    _bannerAd = banner;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: _bannerAd!.size.height.toDouble(),
        color: Colors.transparent,
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return const SizedBox.shrink();
  }
}
