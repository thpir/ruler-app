import 'package:flutter/material.dart';
import 'package:ruler_app/services/shared_prefs_service.dart';

class UiModeController with ChangeNotifier {
  String _uiMode = 'ui';

  UiModeController() {
    getUiModeFromPrefs();
  }

  Future<void> getUiModeFromPrefs() async {
    await SharedPrefsService.getStringValue(SharedPrefsService.UI_MODE)
        .then((value) {
      if (value == '') {
        _uiMode = 'ui';
      } else {
        _uiMode = value.toString();
      }
      notifyListeners();
    });
  }

  String get uiMode => _uiMode;

  set uiMode(String newValue) {
    _uiMode = newValue;
    SharedPrefsService.setStringValue(SharedPrefsService.UI_MODE, newValue);
    notifyListeners();
  }

  static bool isPhoneInDarkMode(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  bool checkIfLightOrDark(BuildContext context) {
    if (uiMode == 'dark') {
      return true;
    } else if (uiMode == 'light') {
      return false;
    } else {
      final darkMode = isPhoneInDarkMode(context);
      if (darkMode) {
        return true;
      } else {
        return false;
      }
    }
  }
}
