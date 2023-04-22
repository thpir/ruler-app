import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared_prefs/calibration_preference.dart';
import '../providers/calibration_provider.dart';
import '../screens/calibration_screen.dart';

class ListTileCalibration extends StatefulWidget {
  const ListTileCalibration({super.key});

  @override
  State<ListTileCalibration> createState() => _ListTileCalibrationState();
}

class _ListTileCalibrationState extends State<ListTileCalibration> {
  String calibrationMode = '';

  @override
  void initState() {
    super.initState();
    getCalibrationMode().then((value) {
      setState(() {
        calibrationMode = value.toString();
      });
    });
  }

  Future<String> getCalibrationMode() async {
    CalibrationPreference calibrationPreference = CalibrationPreference();
    return calibrationPreference.getCalibrationChoice();
  }

  @override
  Widget build(BuildContext context) {
    final calibrationChange = Provider.of<CalibrationProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'Use default calibration',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            value: 'default',
            groupValue: calibrationMode,
            onChanged: ((value) async {
              setState(() {
                calibrationMode = value.toString();
              });
              calibrationChange.calibrationMode = value.toString();
            })),
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'Use custom calibration',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            value: 'custom',
            groupValue: calibrationMode,
            onChanged: ((value) async {
              setState(() {
                calibrationMode = value.toString();
              });
              calibrationChange.calibrationMode = value.toString();
            })),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the drawer
              Navigator.of(context)
                  .pushNamed(CalibrationScreen.routeName); // Open the calibration screen on top of the main screen
            }, 
            child: const Text(
              'Calibrate ruler',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 16,
              ),
            )),
        )
      ],
    );
  }
}
