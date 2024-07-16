import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import 'package:ruler_app/controllers/calibration_controller.dart';
import 'package:ruler_app/views/screens/calibration_screen.dart';


class ListTileCalibration extends StatelessWidget {
  const ListTileCalibration({super.key});

  @override
  Widget build(BuildContext context) {
    final calibrationChange = Provider.of<CalibrationController>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'calibration_default'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: 'default',
            groupValue: calibrationChange.calibrationMode,
            onChanged: ((value) async {
              calibrationChange.setCalibrationMode(value.toString());
            })),
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'calibration_custom'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: 'custom',
            groupValue: calibrationChange.calibrationMode,
            onChanged: ((value) async {
              calibrationChange.setCalibrationMode(value.toString());
            })),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context); // Close the drawer
                Navigator.of(context).pushNamed(CalibrationScreen
                    .routeName); // Open the calibration screen on top of the main screen
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.amber),
              ),
              child: Text(
                'button_text_calibration'.i18n(),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
            ))
      ],
    );
  }
}