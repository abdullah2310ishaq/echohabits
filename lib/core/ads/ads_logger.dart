import 'package:flutter/foundation.dart';
import 'package:habit_tracker/core/ads/admob_ids.dart';

class AdsLogger {
  static const bool _adsLogsEnabled = bool.fromEnvironment('ADS_LOGS');

  static bool get _shouldLog => kDebugMode || kProfileMode || _adsLogsEnabled;

  static void logConfig({String tag = 'Ads'}) {
    if (!_shouldLog) return;

    debugPrint(
      '[$tag] mode='
      '${kReleaseMode ? 'release' : (kProfileMode ? 'profile' : 'debug')} '
      'appId=${AdMobIds.androidAppId} '
      'interstitial=${AdMobIds.interstitialUnitId} '
      'appOpen=${AdMobIds.appOpenUnitId} ',
    );
  }

  static void log(String message, {String tag = 'Ads'}) {
    if (!_shouldLog) return;
    debugPrint('[$tag] $message');
  }
}
