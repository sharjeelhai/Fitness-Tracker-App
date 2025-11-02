import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance => _preferences!;

  // Keys
  static const String _themeKey = 'theme_mode';
  static const String _firstLaunchKey = 'first_launch';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _unitSystemKey = 'unit_system'; // metric or imperial

  // Theme
  static Future<void> setThemeMode(String themeMode) async {
    await instance.setString(_themeKey, themeMode);
  }

  static String getThemeMode() {
    return instance.getString(_themeKey) ?? 'system';
  }

  // First Launch
  static Future<void> setFirstLaunch(bool isFirst) async {
    await instance.setBool(_firstLaunchKey, isFirst);
  }

  static bool isFirstLaunch() {
    return instance.getBool(_firstLaunchKey) ?? true;
  }

  // Notifications
  static Future<void> setNotificationsEnabled(bool enabled) async {
    await instance.setBool(_notificationsKey, enabled);
  }

  static bool getNotificationsEnabled() {
    return instance.getBool(_notificationsKey) ?? true;
  }

  // Unit System
  static Future<void> setUnitSystem(String system) async {
    await instance.setString(_unitSystemKey, system);
  }

  static String getUnitSystem() {
    return instance.getString(_unitSystemKey) ?? 'metric';
  }

  // Clear all preferences
  static Future<void> clearAll() async {
    await instance.clear();
  }
}
