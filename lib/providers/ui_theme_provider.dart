import 'package:flutter/material.dart';

import '../shared_prefs/ui_theme_preference.dart';

class UiThemeProvider with ChangeNotifier {

  // Create an instance of 'UiThemePreference' and assign it to a member 
  // variable: uiThemePreference
  UiThemePreference uiThemePreference = UiThemePreference();
  String _uiMode = 'ui';

  // This is the constructor for the UiThemeProvider class. When an instance of 
  // this class is created, this code block runs. It calls the getUiTheme 
  // method of the uiThemePreference instance, which returns a future. The then 
  // method is used to execute a callback function when the future completes. 
  // This function sets the _uiMode variable to the value returned from the 
  // getUiTheme method and notifies any listeners that the internal state has 
  // changed.
  UiThemeProvider() {
    uiThemePreference.getUiTheme().then((value) {
      _uiMode = value;
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
    uiThemePreference.setUiTheme(newValue);
    notifyListeners();
  }
}
