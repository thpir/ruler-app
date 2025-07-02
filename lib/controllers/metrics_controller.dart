import 'package:flutter/material.dart';
import 'package:ruler_app/services/shared_prefs_service.dart';

class MetricsController extends ChangeNotifier {
  String _metrics = 'mm';

  MetricsController() {
    getMetricsFromPrefs();
  }

  String get metrics => _metrics;

  Future<void> setMetrics(String newValue) async {
    _metrics = newValue;
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
