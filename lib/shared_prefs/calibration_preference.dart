import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class CalibrationPreference {
  static const calibrationMode = 'calibration_mode';
  static const calibrationValue = 'calibration_value';

  setCalibrationChoice(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(calibrationMode, value);
  }

  setCalibrationValue(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(calibrationValue, value);
  }

  Future<String> getCalibrationChoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(calibrationMode) ?? 'default';
  }

  Future<double> getCalibrationValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(calibrationValue) ?? 160;
  }
}
