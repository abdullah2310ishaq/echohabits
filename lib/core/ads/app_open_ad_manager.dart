import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/core/ads/admob_ids.dart';

class AppOpenAdManager {
  static const bool _isEnabled = true;
  static const Duration _maxCacheAge = Duration(hours: 4);

  static AppOpenAd? _appOpenAd;
  static DateTime? _adLoadedAt;
  static bool _isShowingAd = false;
  static bool _isLoadingAd = false;
  static bool _suppressNextResumeAd = false;

  static void initialize() {
    if (!_isEnabled) return;
    _loadAd();
  }

  /// Prevent showing an App Open ad on the next resume.
  ///
  /// Useful when launching external activities (image picker, camera, permissions)
  /// where an interstitial can break the in-flight user action.
  static void suppressNextResumeOnce() {
    _suppressNextResumeAd = true;
  }

  static void onAppResumedFromBackground() {
    if (!_isEnabled || _isShowingAd) {
      return;
    }

    if (_suppressNextResumeAd) {
      _suppressNextResumeAd = false;
      return;
    }

    if (!_isAdAvailable()) {
      _loadAd();
      return;
    }

    final ad = _appOpenAd;
    if (ad == null) {
      _loadAd();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadAd();
      },
    );

    _isShowingAd = true;
    ad.show();
    _appOpenAd = null;
  }

  static bool _isAdAvailable() {
    if (_appOpenAd == null || _adLoadedAt == null) {
      return false;
    }
    return DateTime.now().difference(_adLoadedAt!) < _maxCacheAge;
  }

  static void _loadAd() {
    if (_isLoadingAd || _isAdAvailable()) {
      return;
    }

    _isLoadingAd = true;
    AppOpenAd.load(
      adUnitId: AdMobIds.appOpenUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd?.dispose();
          _appOpenAd = ad;
          _adLoadedAt = DateTime.now();
          _isLoadingAd = false;
        },
        onAdFailedToLoad: (error) {
          _isLoadingAd = false;
          _appOpenAd = null;
        },
      ),
    );
  }
}
