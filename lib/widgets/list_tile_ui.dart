import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared_prefs/ui_theme_preference.dart';
import '../providers/ui_theme_provider.dart';

class ListTileUi extends StatefulWidget {
  const ListTileUi({super.key});

  @override
  State<ListTileUi> createState() => _ListTileUiState();
}

class _ListTileUiState extends State<ListTileUi> {
  String uiMode = '';

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
            activeColor: const Color(0xFFFFC501),
            title: const Text('UI-mode'),
            value: 'ui',
            groupValue: uiMode,
            onChanged: ((value) async {
              setState(() {
                uiMode = value.toString();
              });
              themeChange.uiMode = value.toString();
            })),
        RadioListTile(
            activeColor: const Color(0xFFFFC501),
            title: const Text('Dark-mode'),
            value: 'dark',
            groupValue: uiMode,
            onChanged: ((value) async {
              setState(() {
                uiMode = value.toString();
              });
              themeChange.uiMode = value.toString();
            })),
        RadioListTile(
            activeColor: const Color(0xFFFFC501),
            title: const Text('Light-mode'),
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
