import 'package:flutter/material.dart';

import '../shared_prefs/calibration_preference.dart';

class CalibrationProvider extends ChangeNotifier {
  CalibrationPreference calibrationPreference = CalibrationPreference();
  String _calibrationMode = 'default';
  double _calibrationValue = 160;

  CalibrationProvider() {
    calibrationPreference.getCalibrationValue().then((value) {
      _calibrationValue = value;
      notifyListeners();
    });
    calibrationPreference.getCalibrationChoice().then((value) {
      _calibrationMode = value;
      notifyListeners();
    });
  }

  String get calibrationMode => _calibrationMode;

  set calibrationMode(String newValue) {
    _calibrationMode = newValue;
    calibrationPreference.setCalibrationChoice(newValue);
    notifyListeners();
  }

  double get calibrationValue => _calibrationValue;

  set calibrationValue(double newValue) {
    _calibrationValue = newValue;
    calibrationPreference.setCalibrationValue(newValue);
    notifyListeners();
  }
}
