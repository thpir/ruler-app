import 'package:flutter/material.dart';
import 'package:ruler_app/services/shared_prefs_service.dart';

//import '../services/calibration_preference.dart';

class CalibrationController extends ChangeNotifier {
  //CalibrationPreference calibrationPreference = CalibrationPreference();
  String _calibrationMode = 'default';
  double _calibrationValue = 160;

  // Constructor to retrieve the saved preferences of the user
  CalibrationController() {
    // The calibrationValue is a constant value used to display ruler correctly
    // in case we cannot access the screen properties and have to use a custom
    // calibration.
    // calibrationPreference.getCalibrationValue().then((value) {
    //   _calibrationValue = value;
    //   notifyListeners();
    // });
    getCalibrationValueFromPrefs();

    // The calibrationChoice keeps track whether the user selected default or
    // custom ruler calibration.
    // calibrationPreference.getCalibrationChoice().then((value) {
    //   _calibrationMode = value;
    //   notifyListeners();
    // });
    getCalibrationModeFromPrefs();
  }

  // Getter for setting the calibrationMode.
  String get calibrationMode => _calibrationMode;

  // Setter to save the chosen calibrationMode.
  Future<void> setCalibrationMode(String newValue) async {
    _calibrationMode = newValue;
    //calibrationPreference.setCalibrationChoice(newValue);
    await SharedPrefsService.setStringValue(
        SharedPrefsService.CALIBRATION_MODE, newValue);
    notifyListeners();
  }

  // Getter for setting the custom calibrationValue.
  double get calibrationValue => _calibrationValue;

  // Setter to save the calibration.
  Future<void> setCalibrationValue(double newValue) async {
    _calibrationValue = newValue;
    //calibrationPreference.setCalibrationValue(newValue);
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
