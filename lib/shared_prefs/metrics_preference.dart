import 'package:shared_preferences/shared_preferences.dart';

class MetricsPreference {
  static const metrics = 'metrics';

  setMetrics(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(metrics, value);
  }

  Future<String> getMetrics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(metrics) ?? 'mm';
  }
}