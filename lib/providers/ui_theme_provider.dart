import 'package:flutter/material.dart';

import '../shared_prefs/ui_theme_preference.dart';

class UiThemeProvider extends ChangeNotifier {
  UiThemePreference uiThemePreference = UiThemePreference();
  String _uiMode = 'ui';

  String get uiMode => _uiMode;

  set uiMode(String newValue) {
    _uiMode = newValue;
    uiThemePreference.setUiTheme(newValue);
    notifyListeners();
  }
}
