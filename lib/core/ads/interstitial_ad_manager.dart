import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/core/ads/admob_ids.dart';
import 'package:habit_tracker/core/services/remote_config_service.dart';

class InterstitialAdManager {
  static const Duration _maxCacheAge = Duration(hours: 4);

  static InterstitialAd? _interstitialAd;
  static DateTime? _adLoadedAt;
  static bool _isLoadingAd = false;
  static bool _isShowingAd = false;

  static void initialize() {
    _loadAd();
  }

  static Future<bool> showIfAvailable() async {
    if (_isShowingAd ||
        !RemoteConfigService.showSplashAds ||
        !RemoteConfigService.showSplashInterstitialAd) {
      return false;
    }

    if (!_isAdAvailable()) {
      _loadAd();
      return false;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      _loadAd();
      return false;
    }

    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _interstitialAd = null;
        _loadAd();
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _interstitialAd = null;
        _loadAd();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    _isShowingAd = true;
    ad.show();
    _interstitialAd = null;
    return completer.future;
  }

  static bool _isAdAvailable() {
    if (_interstitialAd == null || _adLoadedAt == null) {
      return false;
    }
    return DateTime.now().difference(_adLoadedAt!) < _maxCacheAge;
  }

  static void _loadAd() {
    if (_isLoadingAd || _isAdAvailable()) {
      return;
    }

    _isLoadingAd = true;
    InterstitialAd.load(
      adUnitId: AdMobIds.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd?.dispose();
          _interstitialAd = ad;
          _adLoadedAt = DateTime.now();
          _isLoadingAd = false;
        },
        onAdFailedToLoad: (error) {
          _isLoadingAd = false;
          _interstitialAd = null;
        },
      ),
    );
  }
}

