import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/core/ads/admob_ids.dart';
import 'package:habit_tracker/core/ads/ads_logger.dart';
import 'package:habit_tracker/core/services/remote_config_service.dart';
import 'package:flutter/foundation.dart';

class AppOpenAdManager {
  static const Duration _maxCacheAge = Duration(hours: 4);

  static AppOpenAd? _appOpenAd;
  static DateTime? _adLoadedAt;
  static bool _isShowingAd = false;
  static bool _isLoadingAd = false;
  static bool _suppressNextResumeAd = false;

  static void initialize() {
    _loadAd();
  }

  static bool isAdAvailable() {
    if (_isShowingAd || !RemoteConfigService.showSplashAppOpenAd) {
      return false;
    }
    return _isAdAvailable();
  }

  static void loadAdIfNeeded() {
    _loadAd();
  }

  static Future<bool> showIfAvailable() async {
    if (_isShowingAd || !RemoteConfigService.showSplashAppOpenAd) {
      AdsLogger.log(
        'skip showIfAvailable (isShowing=$_isShowingAd, rcShowSplashAppOpen=${RemoteConfigService.showSplashAppOpenAd})',
        tag: 'AppOpenAd',
      );
      return false;
    }

    if (!_isAdAvailable()) {
      AdsLogger.log(
        'not available -> load',
        tag: 'AppOpenAd',
      );
      _loadAd();
      return false;
    }

    final ad = _appOpenAd;
    if (ad == null) {
      AdsLogger.log('available=true but ad==null -> load', tag: 'AppOpenAd');
      _loadAd();
      return false;
    }

    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        AdsLogger.log('dismissed', tag: 'AppOpenAd');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadAd();
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        AdsLogger.log(
          'failedToShow code=${error.code} message=${error.message}',
          tag: 'AppOpenAd',
        );
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadAd();
        if (!completer.isCompleted) completer.complete(false);
      },
      onAdShowedFullScreenContent: (ad) {
        AdsLogger.log('showed', tag: 'AppOpenAd');
      },
    );

    _isShowingAd = true;
    AdsLogger.log('show()', tag: 'AppOpenAd');
    ad.show();
    _appOpenAd = null;
    return completer.future;
  }


  static void suppressNextResumeOnce() {
    _suppressNextResumeAd = true;
    AdsLogger.log('suppressNextResumeOnce()', tag: 'AppOpenAd');
  }

  static void onAppResumedFromBackground() {
    if (_isShowingAd) {
      AdsLogger.log('resume ignored (already showing)', tag: 'AppOpenAd');
      return;
    }

    if (_suppressNextResumeAd) {
      _suppressNextResumeAd = false;
      AdsLogger.log('resume suppressed once', tag: 'AppOpenAd');
      return;
    }

    if (!_isAdAvailable()) {
      AdsLogger.log('resume: not available -> load', tag: 'AppOpenAd');
      _loadAd();
      return;
    }

    final ad = _appOpenAd;
    if (ad == null) {
      AdsLogger.log('resume: available=true but ad==null -> load', tag: 'AppOpenAd');
      _loadAd();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        AdsLogger.log('dismissed (resume)', tag: 'AppOpenAd');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        AdsLogger.log(
          'failedToShow (resume) code=${error.code} message=${error.message}',
          tag: 'AppOpenAd',
        );
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadAd();
      },
      onAdShowedFullScreenContent: (ad) {
        AdsLogger.log('showed (resume)', tag: 'AppOpenAd');
      },
    );

    _isShowingAd = true;
    AdsLogger.log('show() (resume)', tag: 'AppOpenAd');
    ad.show();
    _appOpenAd = null;
  }

  static bool _isAdAvailable() {
    final loadedAt = _adLoadedAt;
    if (_appOpenAd == null || loadedAt == null) {
      return false;
    }
    return DateTime.now().difference(loadedAt) < _maxCacheAge;
  }

  static void _loadAd() {
    if (_isLoadingAd || _isAdAvailable()) {
      return;
    }

    _isLoadingAd = true;
    if (kDebugMode) {
      debugPrint('[AppOpenAd] loading... unitId=${AdMobIds.appOpenUnitId}');
    }
    AppOpenAd.load(
      adUnitId: AdMobIds.appOpenUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd?.dispose();
          _appOpenAd = ad;
          _adLoadedAt = DateTime.now();
          _isLoadingAd = false;
          if (kDebugMode) {
            debugPrint('[AppOpenAd] loaded');
          }
        },
        onAdFailedToLoad: (error) {
          _isLoadingAd = false;
          _appOpenAd = null;
          if (kDebugMode) {
            debugPrint(
              '[AppOpenAd] failedToLoad code=${error.code} message=${error.message}',
            );
          }
        },
      ),
    );
  }
}
