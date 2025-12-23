import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static InterstitialAd? _interstitialAd;
  static bool _isAdLoaded = false;

  // ⚠️ TEST ID. Create an 'Interstitial' unit in AdMob to get your real ID later.
  static final String _adUnitId =
      Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712' // Test Android Interstitial
          : 'ca-app-pub-3940256099942544/4411468910'; // Test iOS Interstitial

  /// Loads an ad in the background. Call this when your screen initializes.
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          // When ad is closed, dispose it and load a fresh one
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              loadInterstitialAd(); // Preload the next one
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          print('Interstitial failed to load: $err');
          _isAdLoaded = false;
        },
      ),
    );
  }

  /// Shows the ad if ready.
  static void showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
      _isAdLoaded = false; // Mark as consumed
      _interstitialAd = null;
    } else {
      print('Interstitial ad not ready yet.');
      // Optional: Load it now so it's ready for next time
      loadInterstitialAd();
    }
  }
}
