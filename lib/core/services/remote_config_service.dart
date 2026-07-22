import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static FirebaseRemoteConfig? _remoteConfig;
  static bool _initialized = false;

  static const String keyLanguageNativeAd = 'language_native_ad';
  static const String keyLeaderboardNativeAd = 'leaderboard_native_ad';
  static const String keyHabitCarpoolNativeAd = 'habit_carpool_native_ad';
  static const String keyHistoryNativeAd = 'history_native_ad';
  static const String keyHomeScreenTaskCompleteInterAd =
      'home_screen_task_complete_inter_ad';
  static const String keyNavigationBarInterAd = 'navigation_bar_inter_ad';
  static const String keyProfileBannerAd = 'profile_banner_ad';
  static const String keyHabitAddInterAd = 'habit_add_inter_ad';
  static const String keyShowHomeShellNativeAd = 'show_native_home_shell_ad';
  static const String keySplashAppOpenAd = 'splash_app_open_ad';
  static const String keySplashInterAd = 'splash_inter_ad';
  static const String keyCacheAppOpenAd = 'cache_app_open_ad';

  static Future<void> init() async {
    if (_initialized) return;

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 0),
      ),
    );

    await remoteConfig.setDefaults(const {
      keyLanguageNativeAd: true,
      keyLeaderboardNativeAd: true,
      keyHabitCarpoolNativeAd: true,
      keyHistoryNativeAd: true,
      keyHomeScreenTaskCompleteInterAd: true,
      keyNavigationBarInterAd: true,
      keyProfileBannerAd: true,
      keyHabitAddInterAd: true,
      keyShowHomeShellNativeAd: true,
      keySplashAppOpenAd: true,
      keySplashInterAd: false,
      keyCacheAppOpenAd: true,
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

  static bool get languageNativeAd =>
      _getBool(keyLanguageNativeAd, fallback: true);

  static bool get leaderboardNativeAd =>
      _getBool(keyLeaderboardNativeAd, fallback: true);

  static bool get habitCarpoolNativeAd =>
      _getBool(keyHabitCarpoolNativeAd, fallback: true);

  static bool get historyNativeAd =>
      _getBool(keyHistoryNativeAd, fallback: true);

  static bool get homeScreenTaskCompleteInterAd =>
      _getBool(keyHomeScreenTaskCompleteInterAd, fallback: true);

  static bool get navigationBarInterAd =>
      _getBool(keyNavigationBarInterAd, fallback: true);

  static bool get profileBannerAd =>
      _getBool(keyProfileBannerAd, fallback: true);

  static bool get habitAddInterAd =>
      _getBool(keyHabitAddInterAd, fallback: true);

  static bool get showHomeShellNativeAd =>
      _getBool(keyShowHomeShellNativeAd, fallback: true);

  static bool get splashAppOpenAd =>
      _getBool(keySplashAppOpenAd, fallback: true);

  static bool get splashInterAd => _getBool(keySplashInterAd, fallback: false);

  static bool get cacheAppOpenAd =>
      _getBool(keyCacheAppOpenAd, fallback: true);
}
