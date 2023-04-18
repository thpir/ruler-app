import 'package:flutter/material.dart';

import './list_tile_ui.dart';
import './list_tile_calibration.dart';
import './metrics_toggle_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/ruler.png'),
              ),
              const Spacer(),
              Text(
                'Ruler Settings',
                style: Theme.of(context).textTheme.headline6,
              )
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select your theme:',
                  style: Theme.of(context).textTheme.bodyText1,
                  ),
              ),
              const ListTileUi(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select unit:',
                  style: Theme.of(context).textTheme.bodyText1,
                  ),
              ),
              const MetricsToggleButton(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ruler calibration:',
                  style: Theme.of(context).textTheme.bodyText1,
                  ),
              ),
              const ListTileCalibration(),
            ],
          ),
        )
      ],
    ));
  }
}
