import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import 'package:ruler_app/controllers/calibration_controller.dart';
import 'package:ruler_app/controllers/metrics_controller.dart';
import 'package:ruler_app/controllers/ui_mode_controller.dart';


class CalibrationScreen extends StatefulWidget {
  static const routeName = '/calibration-screen';
  const CalibrationScreen({super.key});

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  double _height = 400.0;

  @override
  Widget build(BuildContext context) {
    // rulerPinWidth method returns the size of the ruler pin. If the ruler pin is a
    // full cm/inch that pin will have to be larger that a ruler pin indicating
    // a value in between two centimeters/inches.
    double rulerPinWidth(int index, String metrics) {
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

    // This method builds the ruler that we render on the screen. The ruler
    // basically consists of containers with a height that matches one mm or
    // inch on the screen. Now that we are in calibrating mode, this won't be
    // an actual mm. The ruler will be resizable to match exactly 5 cm or 2
    // inches.
    List<Container> verticalRulerPin(int count, String metrics) {
      return List.generate(count, (index) {
        return Container(
          height: metrics == 'mm' ? (_height / 50) : (_height / 16),
          width: rulerPinWidth(index, metrics),
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
        title: Text('appbar_calibration_text'.i18n(),
            style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.amber,
        actions: <Widget>[
          Consumer<CalibrationController>(
            builder: (context, calibrationController, _) {
              return IconButton(
                onPressed: () {
                  double newCalibrationValue = _height / 50;
                  calibrationController.setCalibrationValue(newCalibrationValue);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
              );
            }
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
      body: Stack(
          children: [
            Consumer<UiModeController>(
              builder: (context, uiModeController, _) => Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    image: DecorationImage(
                        image: AssetImage(uiModeController.checkIfLightOrDark(context)
                            ? 'assets/images/background_toolbox_dark.png'
                            : 'assets/images/background_toolbox.png'),
                        fit: BoxFit.cover)),
              ),
            ),
            GestureDetector(
              onVerticalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _height += details.delta.dy;
                });
              },
              child: Consumer<MetricsController>(
                builder: (context, metricsController, _) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: _height,
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 70.0),
                                child: Text(
                                  metricsController.metrics == 'mm'
                                      ? 'calibration_explanation_text_mm'.i18n()
                                      : 'calibration_explanation_text_inch'.i18n(),
                                  style: Theme.of(context).textTheme.titleLarge,
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
                          height: metricsController.metrics == 'mm' ? (_height / 50) : (_height / 16),
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
                          children: metricsController.metrics == 'mm'
                              ? verticalRulerPin(50, metricsController.metrics)
                              : verticalRulerPin(16, metricsController.metrics),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ]),
    );
  }
}
