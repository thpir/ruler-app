import 'package:shared_preferences/shared_preferences.dart';

class UiThemePreference {
  static const uiMode = 'uiMode';

  setUiTheme(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(uiMode, value);
  }

  Future<String> getUiTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(uiMode) ?? 'ui';
  }
}
