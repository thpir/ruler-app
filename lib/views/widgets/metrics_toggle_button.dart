import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import 'package:ruler_app/controllers/metrics_controller.dart';

class MetricsToggleButton extends StatelessWidget {
  const MetricsToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MetricsController>(
      builder: (context, metricsController, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ToggleButtons(
            direction: Axis.horizontal,
            onPressed: (index) {
              metricsController.metrics == 'mm'
                  ? metricsController.setMetrics('in')
                  : metricsController.setMetrics('mm');
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.amber[600],
            selectedColor: Colors.black,
            fillColor: Colors.amber,
            color: Theme.of(context).focusColor,
            constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
            isSelected: [
              metricsController.metrics == 'mm',
              metricsController.metrics == 'in',
            ],
            children: <Widget>[
              Text('millimeters'.i18n()),
              Text('inches'.i18n()),
            ],
          ),
        )
    );
  }
}
