import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings_model.dart';
class SettingsService {
  static const _themeKey = 'theme_index';
  static const _imageQualityKey = 'image_quality';
  static const _exportQualityKey = 'export_quality';
  static const _autoCropKey = 'auto_crop';
  static const _autoFilterKey = 'auto_filter';

  /// تحميل الإعدادات
  static Future<SettingsModel> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return SettingsModel(
      themeIndex: prefs.getInt(_themeKey) ?? 0,
      imageQuality: prefs.getInt(_imageQualityKey) ?? 1,
      exportQuality: prefs.getInt(_exportQualityKey) ?? 1,
      autoCrop: prefs.getBool(_autoCropKey) ?? true,
      autoFilter: prefs.getBool(_autoFilterKey) ?? true,
    );
  }

  /// حفظ كل الإعدادات مرة واحدة
  static Future<void> saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_themeKey, settings.themeIndex);
    await prefs.setInt(_imageQualityKey, settings.imageQuality);
    await prefs.setInt(_exportQualityKey, settings.exportQuality);

    await prefs.setBool(_autoCropKey, settings.autoCrop);
    await prefs.setBool(_autoFilterKey, settings.autoFilter);
  }

  static Future<void> setTheme(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, value);
  }

  static Future<void> setImageQuality(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_imageQualityKey, value);
  }

  static Future<void> setExportQuality(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_exportQualityKey, value);
  }

  static Future<void> setAutoCrop(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoCropKey, value);
  }

  static Future<void> setAutoFilter(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoFilterKey, value);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_themeKey, 0);
    await prefs.setInt(_imageQualityKey, 1);
    await prefs.setInt(_exportQualityKey, 1);

    await prefs.setBool(_autoCropKey, true);
    await prefs.setBool(_autoFilterKey, true);
  }
}