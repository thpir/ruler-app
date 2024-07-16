import 'package:flutter/material.dart';
import 'package:ruler_app/services/shared_prefs_service.dart';

//import '../services/metrics_preference.dart';

class MetricsController extends ChangeNotifier {
  // Create an instance of 'MetricsPreference' and assign it to a member
  // variable: metricsPreference
  //etricsPreference metricsPreference = MetricsPreference();
  String _metrics = 'mm';

  // Constructor to retrieve the preferred metric choice previously selected
  // by the user.
  MetricsController() {
    // metricsPreference.getMetrics().then((value) {
    //   _metrics = value;
    //   notifyListeners();
    // });
    getMetricsFromPrefs();
  }

  // Getter to retrieve the metrics.
  String get metrics => _metrics;

  // Setter to save the newly selected metrics.
  Future<void> setMetrics(String newValue) async {
    _metrics = newValue;
    //metricsPreference.setMetrics(newValue);
    await SharedPrefsService.setStringValue(SharedPrefsService.METRICS, newValue);
    notifyListeners();
  }

  Future<void> getMetricsFromPrefs() async {
    await SharedPrefsService.getStringValue(SharedPrefsService.METRICS)
        .then((value) {
      if (value == '') {
        _metrics = 'mm';
      } else {
        _metrics = value.toString();
      }
      notifyListeners();
    });
  }
}
