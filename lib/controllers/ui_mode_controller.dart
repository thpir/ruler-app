import 'package:flutter/material.dart';
import 'package:ruler_app/services/shared_prefs_service.dart';

//import '../services/ui_theme_preference.dart';

class UiModeController with ChangeNotifier {
  // Create an instance of 'UiThemePreference' and assign it to a member
  // variable: uiThemePreference
  //UiThemePreference uiThemePreference = UiThemePreference();
  String _uiMode = 'ui';

  // This is the constructor for the UiThemeProvider class. When an instance of
  // this class is created, this code block runs. It calls the getUiTheme
  // method of the uiThemePreference instance, which returns a future. The then
  // method is used to execute a callback function when the future completes.
  // This function sets the _uiMode variable to the value returned from the
  // getUiTheme method and notifies any listeners that the internal state has
  // changed.
  UiModeController() {
    getUiModeFromPrefs();
    // uiThemePreference.getUiTheme().then((value) {
    //   _uiMode = value;
    //   notifyListeners();
    // });
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

  // This is a getter method named uiMode that returns the value of the
  // private _uiMode variable.
  String get uiMode => _uiMode;

  // This is a setter method named uiMode that sets the value of the private
  // _uiMode variable. It also calls the setUiTheme method of the
  // uiThemePreference instance with the new value, and notifies any listeners
  // that the internal state has changed.
  set uiMode(String newValue) {
    _uiMode = newValue;
    //uiThemePreference.setUiTheme(newValue);
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
