import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/core/ads/admob_ids.dart';
import 'package:habit_tracker/core/ads/ads_logger.dart';
import 'package:habit_tracker/core/services/remote_config_service.dart';
import 'package:flutter/foundation.dart';

class InterstitialAdManager {
  static const Duration _maxCacheAge = Duration(hours: 4);

  static InterstitialAd? _interstitialAd;
  static DateTime? _adLoadedAt;
  static bool _isLoadingAd = false;
  static bool _isShowingAd = false;

  static void initialize() {
    _loadAd();
  }

  /// Shows an interstitial if it is available.
  ///
  /// - When [fromSplash] is true, it respects splash remote-config gates.
  /// - When [fromSplash] is false, it is allowed outside splash (e.g. habits flow).
  static Future<bool> showIfAvailable({bool fromSplash = false}) async {
    if (_isShowingAd) {
      AdsLogger.log('skip showIfAvailable (already showing)', tag: 'InterstitialAd');
      return false;
    }

    if (fromSplash &&
        (!RemoteConfigService.showSplashAds ||
            !RemoteConfigService.showSplashInterstitialAd)) {
      AdsLogger.log(
        'skip fromSplash due to remote config (showSplashAds=${RemoteConfigService.showSplashAds}, showSplashInterstitial=${RemoteConfigService.showSplashInterstitialAd})',
        tag: 'InterstitialAd',
      );
      return false;
    }

    if (!_isAdAvailable()) {
      AdsLogger.log('not available -> load', tag: 'InterstitialAd');
      _loadAd();
      return false;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      AdsLogger.log('available=true but ad==null -> load', tag: 'InterstitialAd');
      _loadAd();
      return false;
    }

    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        AdsLogger.log('dismissed', tag: 'InterstitialAd');
        _isShowingAd = false;
        ad.dispose();
        _interstitialAd = null;
        _loadAd();
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        AdsLogger.log(
          'failedToShow code=${error.code} message=${error.message}',
          tag: 'InterstitialAd',
        );
        _isShowingAd = false;
        ad.dispose();
        _interstitialAd = null;
        _loadAd();
        if (!completer.isCompleted) completer.complete(false);
      },
      onAdShowedFullScreenContent: (ad) {
        AdsLogger.log('showed', tag: 'InterstitialAd');
      },
    );

    _isShowingAd = true;
    AdsLogger.log('show() fromSplash=$fromSplash', tag: 'InterstitialAd');
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
    if (kDebugMode) {
      debugPrint('[InterstitialAd] loading... unitId=${AdMobIds.interstitialUnitId}');
    }
    InterstitialAd.load(
      adUnitId: AdMobIds.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd?.dispose();
          _interstitialAd = ad;
          _adLoadedAt = DateTime.now();
          _isLoadingAd = false;
          if (kDebugMode) {
            debugPrint('[InterstitialAd] loaded');
          }
        },
        onAdFailedToLoad: (error) {
          _isLoadingAd = false;
          _interstitialAd = null;
          if (kDebugMode) {
            debugPrint(
              '[InterstitialAd] failedToLoad code=${error.code} message=${error.message}',
            );
          }
        },
      ),
    );
  }
}
