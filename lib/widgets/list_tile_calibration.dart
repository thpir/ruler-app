import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared_prefs/ui_theme_preference.dart';
import '../providers/ui_theme_provider.dart';

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
    /*getUiTheme().then((value) {
      setState(() {
        uiMode = value.toString();
      });
    });*/
  }

  /*Future<String> getUiTheme() async {
    UiThemePreference uiThemePreferene = UiThemePreference();
    return uiThemePreferene.getUiTheme();
  }*/

  @override
  Widget build(BuildContext context) {
    //final themeChange = Provider.of<UiThemeProvider>(context);
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
            onChanged: null
            /*((value) async {
              setState(() {
                uiMode = value.toString();
              });
              themeChange.uiMode = value.toString();
            })*/),
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'Use custom calibration',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            value: 'dark',
            groupValue: calibrationMode,
            onChanged: null
            /*((value) async {
              setState(() {
                uiMode = value.toString();
              });
              themeChange.uiMode = value.toString();
            })*/),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ElevatedButton(
            onPressed: () {}, 
            child: const Text('Calibrate ruler')),
        )
      ],
    );
  }
}
