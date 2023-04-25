import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';

import '../shared_prefs/metrics_preference.dart';
import '../providers/metrics_provider.dart';

class MetricsToggleButton extends StatefulWidget {
  const MetricsToggleButton({super.key});

  @override
  State<MetricsToggleButton> createState() => _MetricsToggleButtonState();
}

class _MetricsToggleButtonState extends State<MetricsToggleButton> {
  String metrics = '';

  final List<Widget> _metrics = <Widget>[
    Text('millimeters'.i18n()),
    Text('inches'.i18n()),
  ];
  final List<bool> _selectedMetrics = <bool>[
    true,
    false,
  ];

  @override
  void initState() {
    super.initState();
    getMetrics().then((value) {
      metrics = value.toString();
      setToggleButton();
    });
  }

  Future<String> getMetrics() async {
    MetricsPreference metricsPreference = MetricsPreference();
    return metricsPreference.getMetrics();
  }

  void setToggleButton() {
    if (metrics == 'mm') {
      setState(() {
        _selectedMetrics[0] = true;
        _selectedMetrics[1] = false;
      });
    } else {
      setState(() {
        _selectedMetrics[0] = false;
        _selectedMetrics[1] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final metricsChange = Provider.of<MetricsProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (index) {
          //MetricsPreference metricsPreference = MetricsPreference();
          setState(() {
            // The button that is tapped is set to true, and the other one to false
            for (int i = 0; i < _selectedMetrics.length; i++) {
              _selectedMetrics[i] = i == index;
            }
            for (int j = 0; j < _selectedMetrics.length; j++) {
              if (_selectedMetrics[j]) {
                j == 0
                    //? metricsPreference.setMetrics('mm')
                    ? metricsChange.metrics = 'mm'
                    //: metricsPreference.setMetrics('in');
                    : metricsChange.metrics = 'in';
              }
            }
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedBorderColor: Colors.amber[600],
        selectedColor: Colors.black,
        fillColor: Colors.amber,
        color: Theme.of(context).focusColor,
        constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
        isSelected: _selectedMetrics,
        children: _metrics,
      ),
    );
  }
}
