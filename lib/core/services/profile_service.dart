import 'package:hive_flutter/hive_flutter.dart';

class ProfileService {
  static const String _boxName = 'profileBox';
  static const String _nameKey = 'userName';
  static const String _imagePathKey = 'profileImagePath';
  static const String _isSetupCompleteKey = 'isSetupComplete';

  static Box? _box;

  /// Initialize Hive and open profile box
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  /// Check if profile setup is complete
  static bool isProfileSetupComplete() {
    return _box?.get(_isSetupCompleteKey, defaultValue: false) ?? false;
  }

  /// Get user name
  static String getUserName() {
    return _box?.get(_nameKey, defaultValue: 'Liza') ?? 'Liza';
  }

  /// Get profile image path (null if using default)
  static String? getProfileImagePath() {
    return _box?.get(_imagePathKey);
  }

  /// Save profile data
  static Future<void> saveProfile({
    required String name,
    String? imagePath,
  }) async {
    await _box?.put(_nameKey, name);
    if (imagePath != null) {
      await _box?.put(_imagePathKey, imagePath);
    } else {
      await _box?.delete(_imagePathKey);
    }
    await _box?.put(_isSetupCompleteKey, true);
  }

  /// Get greeting based on time
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
