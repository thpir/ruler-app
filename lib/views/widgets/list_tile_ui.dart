import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import 'package:ruler_app/controllers/ui_mode_controller.dart';

class ListTileUi extends StatefulWidget {
  const ListTileUi({super.key});

  @override
  State<ListTileUi> createState() => _ListTileUiState();
}

class _ListTileUiState extends State<ListTileUi> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UiModeController>(
      builder: (context, controller, child) {
        return Column(
          children: <Widget>[
            RadioListTile(
                activeColor: Colors.amber,
                title: Text(
                  'theme_ui'.i18n(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                value: 'ui',
                groupValue: controller.uiMode,
                onChanged: ((value) async {
                  controller.uiMode = value.toString();
                })),
            RadioListTile(
                activeColor: Colors.amber,
                title: Text(
                  'theme_dark'.i18n(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                value: 'dark',
                groupValue: controller.uiMode,
                onChanged: ((value) async {
                  controller.uiMode = value.toString();
                })),
            RadioListTile(
              activeColor: Colors.amber,
              title: Text(
                'theme_light'.i18n(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: 'light',
              groupValue: controller.uiMode,
              onChanged: ((value) async {
                controller.uiMode = value.toString();
              }),
            ),
          ],
        );
      }
    );
  }
}