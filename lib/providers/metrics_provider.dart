import 'package:flutter/material.dart';

import '../shared_prefs/metrics_preference.dart';

class MetricsProvider extends ChangeNotifier {

  // Create an instance of 'MetricsPreference' and assign it to a member 
  // variable: metricsPreference
  MetricsPreference metricsPreference = MetricsPreference();
  String _metrics = 'mm';

  MetricsProvider() {
    metricsPreference.getMetrics().then((value) {
      _metrics = value;
      notifyListeners();
    });
  }

  String get metrics => _metrics;

  set metrics(String newValue) {
    _metrics = newValue;
    metricsPreference.setMetrics(newValue);
    notifyListeners();
  }
}
