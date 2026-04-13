import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static FirebaseRemoteConfig? _remoteConfig;
  static bool _initialized = false;

  static const String keyShowLanguageNativeAd = 'show_native_language_ad';
  static const String keyShowHomeShellNativeAd = 'show_native_home_shell_ad';

  // Splash-specific toggles.
  static const String keyShowSplashAds = 'show_splash_ads';
  static const String keyShowSplashAppOpenAd = 'show_splash_app_open_ad';
  static const String keyShowSplashInterstitialAd =
      'show_splash_interstitial_ad';

  static Future<void> init() async {
    if (_initialized) return;

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await remoteConfig.setDefaults(const {
      keyShowLanguageNativeAd: true,
      keyShowHomeShellNativeAd: true,
      keyShowSplashAds: true,
      keyShowSplashAppOpenAd: true,
      keyShowSplashInterstitialAd: true,
    });

    try {
      await remoteConfig.fetchAndActivate();
    } catch (_) {
      // Defaults are kept when remote config fetch fails.
    }

    _remoteConfig = remoteConfig;
    _initialized = true;
  }

  static Future<void> refresh() async {
    if (!_initialized) {
      await init();
      return;
    }

    final remoteConfig = _remoteConfig;
    if (remoteConfig == null) return;

    try {
      await remoteConfig.fetchAndActivate();
    } catch (_) {
      // Keep last activated values.
    }
  }

  static bool _getBool(String key, {required bool fallback}) {
    if (_remoteConfig == null) return fallback;
    return _remoteConfig!.getBool(key);
  }

  static bool get showLanguageNativeAd =>
      _getBool(keyShowLanguageNativeAd, fallback: true);

  static bool get showHomeShellNativeAd =>
      _getBool(keyShowHomeShellNativeAd, fallback: true);

  static bool get showSplashAds => _getBool(keyShowSplashAds, fallback: true);

  static bool get showSplashAppOpenAd =>
      _getBool(keyShowSplashAppOpenAd, fallback: true);

  static bool get showSplashInterstitialAd =>
      _getBool(keyShowSplashInterstitialAd, fallback: true);
}
