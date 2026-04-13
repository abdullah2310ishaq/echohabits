import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static FirebaseRemoteConfig? _remoteConfig;
  static bool _initialized = false;

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
      'show_ads': true,
      'show_native_language_ad': true,
    });

    try {
      await remoteConfig.fetchAndActivate();
    } catch (_) {
      // Defaults are kept when remote config fetch fails.
    }

    _remoteConfig = remoteConfig;
    _initialized = true;
  }

  static bool _getBool(String key, {required bool fallback}) {
    if (_remoteConfig == null) return fallback;
    return _remoteConfig!.getBool(key);
  }

  static bool get showAds => _getBool('show_ads', fallback: true);

  static bool get showLanguageNativeAd =>
      _getBool('show_native_language_ad', fallback: true);
}
