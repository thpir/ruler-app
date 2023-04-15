import 'package:flutter/material.dart';

import './list_tile_ui.dart';

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
            children: const [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/ruler.png'),
              ),
              Spacer(),
              Text('Ruler Settings')
            ],
          ),
        ),
        const ListTileUi(),
      ],
    ));
  }
}
