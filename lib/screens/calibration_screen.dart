import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared_prefs/metrics_preference.dart';
import '../providers/calibration_provider.dart';

class CalibrationScreen extends StatefulWidget {
  static const routeName = '/calibration-screen';
  const CalibrationScreen({super.key});

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  double _height = 400.0;
  String metrics = 'mm';

  @override
  void initState() {
    super.initState();
    getMetrics().then((value) {
      setState(() {
        metrics = value.toString();
      });
    });
  }

  Future<String> getMetrics() async {
    MetricsPreference metricsPreference = MetricsPreference();
    return metricsPreference.getMetrics();
  }

  @override
  Widget build(BuildContext context) {
    final calibrationChange = Provider.of<CalibrationProvider>(context);

    // rulerPinWidth method returns the size of the ruler pin. If the ruler pin is a
    //full cm/inch that pin will have to be larger that a ruler pin indicating
    //a value in between two centimeters/inches
    double rulerPinWidth(int index) {
      if (metrics == 'mm') {
        if ((index + 1) % 10 == 0) {
          return 40;
        } else {
          return 20;
        }
      } else {
        if ((index + 1) % 8 == 0) {
          return 40;
        } else if ((index + 1) % 2 == 0) {
          return 30;
        } else {
          return 20;
        }
      }
    }

    List<Container> verticalRulerPin(int count) {
      return List.generate(count, (index) {
        return Container(
          height: metrics == 'mm' ? (_height / 50) : (_height / 16),
          width: rulerPinWidth(index),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Theme.of(context).focusColor,
              ),
            ),
          ),
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calibrate Ruler',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold,fontSize: 20)
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              double newCalibrationValue = _height / 50;
              calibrationChange.calibrationValue = newCalibrationValue;
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            setState(() {
              _height += details.delta.dy;
            });
          },
          child: Container(
              color: Theme.of(context).backgroundColor,
              height: _height,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe_up,
                          color: Theme.of(context).focusColor,
                          size: 50,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70.0),
                          child: Text(
                            metrics == 'mm'
                                ? 'Measure 5 centimeters & tab the save button to calibrate. Drag to resize the ruler.'
                                : 'Measure 2 inches & tab the save button to calibrate. Drag to resize the ruler.',
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.swipe_down,
                          color: Theme.of(context).focusColor,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: metrics == 'mm' ? (_height / 50) : (_height / 16),
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Theme.of(context).focusColor,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: metrics == 'mm'
                        ? verticalRulerPin(50)
                        : verticalRulerPin(16),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
