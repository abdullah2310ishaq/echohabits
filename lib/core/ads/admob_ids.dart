import 'package:flutter/foundation.dart';

class AdMobIds {
  static const String androidAppId = 'ca-app-pub-7182112310194934~7606563863';
  static const bool adsTestMode = bool.fromEnvironment('ADS_TEST_MODE');

  static const String nativeLanguageUnitId =
      'ca-app-pub-3940256099942544/2247696110';
  static const String nativeMediumUnitId =
      'ca-app-pub-3940256099942544/2247696110';

  static const String bannerUnitId = 'ca-app-pub-3940256099942544/6300978111';

  // Production IDs (real)
  static const String _prodInterstitialUnitId =
      'ca-app-pub-7182112310194934/5351935618';
  static const String _prodAppOpenUnitId =
      'ca-app-pub-7182112310194934/8180219448';

  // Google test IDs (safe for development)
  static const String _testInterstitialUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testAppOpenUnitId =
      'ca-app-pub-3940256099942544/3419835294';

  static String get interstitialUnitId =>
      (kReleaseMode && !adsTestMode)
          ? _prodInterstitialUnitId
          : _testInterstitialUnitId;

  static String get appOpenUnitId =>
      (kReleaseMode && !adsTestMode) ? _prodAppOpenUnitId : _testAppOpenUnitId;
}
