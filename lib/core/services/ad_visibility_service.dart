import 'package:habit_tracker/core/services/profile_service.dart';
import 'package:habit_tracker/core/services/remote_config_service.dart';

class AdVisibilityService {
  static bool get shouldShowLanguageNativeAd =>
      !ProfileService.isProUser() &&
      RemoteConfigService.showLanguageNativeAd;
}
