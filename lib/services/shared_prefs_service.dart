// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  /// Static variable to hold the single instance of the class
  static SharedPrefsService? _instance; 
  static SharedPreferences? _preferences;
  
  static const String CALIBRATION_MODE = 'calibration_mode';
  static const String CALIBRATION_VALUE = 'calibration_value';
  static const String METRICS = 'metrics';
  static const String UI_MODE = 'uiMode';

  /// Singleton pattern to make sure only one instance of SharedPrefsService 
  /// is created. This is the static method to access the instance, and create 
  /// a new instance if one doesn't exist.
  static Future _getInstance() async {
    _instance ??= SharedPrefsService();
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future<String> getStringValue(String key) async {
    return await _getInstance().then((_) {
      return _preferences!.getString(key) ?? '';
    });
  }

  static Future setStringValue(String key, String value) async {
    await _getInstance().then((_) {
      _preferences!.setString(key, value);
    });
  }

  static Future<double> getDoubleValue(String key) async {
    return await _getInstance().then((_) {
      return _preferences!.getDouble(key) ?? 5.0;
    });
  }

  static Future setDoubleValue(String key, double value) async {
    await _getInstance().then((_) {
      _preferences!.setDouble(key, value);
    });
  }

  static Future<bool> getBoolValue(String key) async {
    return await _getInstance().then((_) {
      return _preferences!.getBool(key) ?? false;
    });
  }

  static Future setBoolValue(String key, bool value) async {
    await _getInstance().then((_) {
      _preferences!.setBool(key, value);
    });
  }

  static Future removeValue(String key) async {
    await _getInstance().then((_) {
      _preferences!.remove(key);
    });
  }

  static Future resetToDefault() async {
    await _getInstance().then((_) {
      _preferences!.clear();
    });
  }
}