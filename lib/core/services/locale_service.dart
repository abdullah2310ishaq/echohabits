import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service to manage app locale/language settings
class LocaleService extends ChangeNotifier {
  static const String _boxName = 'localeBox';
  static const String _localeKey = 'locale';
  static const String _languageSelectedKey = 'languageSelected';

  static Box? _box;

  /// In-memory cache for current locale to prevent stale reads
  Locale? _cachedLocale;

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('es'), // Spanish
    Locale('fr'), // French
    Locale('de'), // German
    Locale('it'), // Italian
    Locale('pt'), // Portuguese
    Locale('ru'), // Russian
    Locale('zh'), // Chinese
    Locale('ja'), // Japanese
    Locale('ko'), // Korean
    Locale('ar'), // Arabic
  ];

  /// Initialize Hive box for locale storage
  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Load locale from storage into cache (call after init)
  void loadLocaleFromStorage() {
    if (_box == null) {
      _cachedLocale = const Locale('en');
      return;
    }
    final localeCode = _box!.get(_localeKey, defaultValue: 'en') as String;
    _cachedLocale = Locale(localeCode);
  }

  /// Get current locale from cache or storage, or return default (English)
  Locale getCurrentLocale() {
    // Return cached locale if available
    if (_cachedLocale != null) return _cachedLocale!;

    // Load from storage if cache is empty
    if (_box == null) {
      _cachedLocale = const Locale('en');
      return _cachedLocale!;
    }

    final localeCode = _box!.get(_localeKey, defaultValue: 'en') as String;
    _cachedLocale = Locale(localeCode);
    return _cachedLocale!;
  }

  /// Set locale and save to storage
  Future<void> setLocale(Locale locale) async {
    if (_box == null) return;

    // Update cache first to prevent stale reads
    _cachedLocale = locale;

    // Save to storage
    await _box!.put(_localeKey, locale.languageCode);

    // Notify listeners after both cache and storage are updated
    notifyListeners();
  }

  /// Set locale by language code (e.g., 'en', 'es', 'fr')
  Future<void> setLocaleByCode(String languageCode) async {
    await setLocale(Locale(languageCode));
    // Mark that language has been selected
    if (_box != null) {
      await _box!.put(_languageSelectedKey, true);
    }
  }

  /// Check if language has been selected (for first-time setup)
  bool isLanguageSelected() {
    if (_box == null) return false;
    return _box!.get(_languageSelectedKey, defaultValue: false) as bool;
  }
}
