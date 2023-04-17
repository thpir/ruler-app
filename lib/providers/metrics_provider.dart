import 'package:flutter/material.dart';

import '../shared_prefs/metrics_preference.dart';

class MetricsProvider extends ChangeNotifier {
  MetricsPreference metricsPreference = MetricsPreference();
  String _metrics = 'mm';

  String get metrics => _metrics;

  set metrics(String newValue) {
    _metrics = newValue;
    metricsPreference.setMetrics(newValue);
    notifyListeners();
  }
}