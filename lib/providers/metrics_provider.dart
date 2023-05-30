import 'package:flutter/material.dart';

import '../shared_prefs/metrics_preference.dart';

class MetricsProvider extends ChangeNotifier {

  // Create an instance of 'MetricsPreference' and assign it to a member 
  // variable: metricsPreference
  MetricsPreference metricsPreference = MetricsPreference();
  String _metrics = 'mm';

  // Constructor to retrieve the preferred metric choice previously selected
  // by the user.
  MetricsProvider() {
    metricsPreference.getMetrics().then((value) {
      _metrics = value;
      notifyListeners();
    });
  }

  // Getter to retrieve the metrics.
  String get metrics => _metrics;

  // Setter to save the newly selected metrics.
  set metrics(String newValue) {
    _metrics = newValue;
    metricsPreference.setMetrics(newValue);
    notifyListeners();
  }
}
