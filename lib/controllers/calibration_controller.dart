import 'package:flutter/material.dart';
import 'package:ruler_app/services/shared_prefs_service.dart';

class CalibrationController extends ChangeNotifier {
  String _calibrationMode = 'default';
  double _calibrationValue = 160;

  CalibrationController() {
    getCalibrationValueFromPrefs();
    getCalibrationModeFromPrefs();
  }

  String get calibrationMode => _calibrationMode;

  Future<void> setCalibrationMode(String newValue) async {
    _calibrationMode = newValue;
    await SharedPrefsService.setStringValue(
        SharedPrefsService.CALIBRATION_MODE, newValue);
    notifyListeners();
  }

  double get calibrationValue => _calibrationValue;

  Future<void> setCalibrationValue(double newValue) async {
    _calibrationValue = newValue;
    await SharedPrefsService.setDoubleValue(
        SharedPrefsService.CALIBRATION_VALUE, newValue);
    notifyListeners();
  }

  Future<void> getCalibrationModeFromPrefs() async {
    await SharedPrefsService.getStringValue(SharedPrefsService.CALIBRATION_MODE)
        .then((value) {
      if (value == '') {
        _calibrationMode = 'default';
      } else {
        _calibrationMode = value.toString();
      }
      notifyListeners();
    });
  }

  Future<void> getCalibrationValueFromPrefs() async {
    await SharedPrefsService.getDoubleValue(
            SharedPrefsService.CALIBRATION_VALUE)
        .then((value) {
      if (value == 0.0) {
        _calibrationValue = 160;
      } else {
        _calibrationValue = value;
      }
      notifyListeners();
    });
  }
}
