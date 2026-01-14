import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service to manage app locale/language settings
class LocaleService extends ChangeNotifier {
  static const String _boxName = 'localeBox';
  static const String _localeKey = 'locale';

  static Box? _box;

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
  ];

  /// Initialize Hive box for locale storage
  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Get current locale from storage or return default (English)
  Locale getCurrentLocale() {
    if (_box == null) return const Locale('en');

    final localeCode = _box!.get(_localeKey, defaultValue: 'en') as String;
    return Locale(localeCode);
  }

  /// Set locale and save to storage
  Future<void> setLocale(Locale locale) async {
    if (_box == null) return;

    await _box!.put(_localeKey, locale.languageCode);
    notifyListeners();
  }

  /// Set locale by language code (e.g., 'en', 'es', 'fr')
  Future<void> setLocaleByCode(String languageCode) async {
    await setLocale(Locale(languageCode));
  }
}
