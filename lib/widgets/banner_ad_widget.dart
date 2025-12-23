import 'dart:io';
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

  // ⚠️ IMPORTANT: Use these TEST IDs for development.
  // Replace with your REAL ID (from your screenshot) ONLY when building for Play Store.
  final String _adUnitId =
      Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' // Test Android Banner
          : 'ca-app-pub-3940256099942544/2934735716'; // Test iOS Banner

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isLoaded = true),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          print('Banner Ad failed to load: $err');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return const SizedBox(); // Hides space if ad fails
  }
}
