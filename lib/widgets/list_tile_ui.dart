import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';

import '../shared_prefs/ui_theme_preference.dart';
import '../providers/ui_theme_provider.dart';

class ListTileUi extends StatefulWidget {
  const ListTileUi({super.key});

  @override
  State<ListTileUi> createState() => _ListTileUiState();
}

class _ListTileUiState extends State<ListTileUi> {
  String uiMode = 'ui';

  @override
  void initState() {
    super.initState();
    getUiTheme().then((value) {
      setState(() {
        uiMode = value.toString();
      });
    });
  }

  Future<String> getUiTheme() async {
    UiThemePreference uiThemePreferene = UiThemePreference();
    return uiThemePreferene.getUiTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<UiThemeProvider>(context);
    return Column(
      children: <Widget>[
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'theme_ui'.i18n(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            value: 'ui',
            groupValue: uiMode,
            onChanged: ((value) async {
              setState(() {
                uiMode = value.toString();
              });
              themeChange.uiMode = value.toString();
            })),
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'theme_dark'.i18n(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            value: 'dark',
            groupValue: uiMode,
            onChanged: ((value) async {
              setState(() {
                uiMode = value.toString();
              });
              themeChange.uiMode = value.toString();
            })),
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'theme_light'.i18n(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            value: 'light',
            groupValue: uiMode,
            onChanged: ((value) async {
              setState(() {
                uiMode = value.toString();
              });
              themeChange.uiMode = value.toString();
            })),
      ],
    );
  }
}
