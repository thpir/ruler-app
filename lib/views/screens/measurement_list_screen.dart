import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import 'package:ruler_app/controllers/ui_mode_controller.dart';

import '../../controllers/measurement_controller.dart';
import '../../models/measurement.dart';

class MeasurementListScreen extends StatefulWidget {
  static const routeName = '/measurement-list-screen';
  const MeasurementListScreen({super.key});

  @override
  State<MeasurementListScreen> createState() => _MeasurementListScreenState();
}

class _MeasurementListScreenState extends State<MeasurementListScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Delete an item from the measurements database.
  void _deleteItem(String id) {
    Provider.of<MeasurementController>(context, listen: false)
        .deleteMeasurement(id);
  }

  // Edit the label of one of the values in the database.
  void _editItem(Measurement measurement) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('edit_title'.i18n(), style: Theme.of(context).textTheme.titleLarge,),
        content: TextField(
          cursorErrorColor: Colors.red,
          controller: _controller,
          cursorColor: Colors.amber,
          decoration: InputDecoration(
            iconColor: Colors.amber,
            fillColor: Colors.transparent,
            hoverColor: Colors.amber,
            prefixIconColor: Colors.amber,
            suffixIconColor: Colors.amber,
            focusColor: Colors.amber,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
            ),
            labelStyle: TextStyle(color: Theme.of(context).focusColor),
            labelText: measurement.description,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('button_text_cancel'.i18n(),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              String editedDescription = _controller.text;
              Provider.of<MeasurementController>(context, listen: false)
                  .updateMeasurement(
                      measurement, editedDescription, measurement.id);
              Navigator.pop(context, 'OK');
            },
            child: Text(
              'button_text_save'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'appbar_history_text'.i18n(),
          style: const TextStyle(
              fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.amber,
      ),
      body: Consumer<UiModeController>(
        builder: (context, controller, child) => Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              image: DecorationImage(
                  image: AssetImage(controller.checkIfLightOrDark(context)
                      ? 'assets/images/background_toolbox_dark.png'
                      : 'assets/images/background_toolbox.png'),
                  fit: BoxFit.cover)),
          child: FutureBuilder(
            future: Provider.of<MeasurementController>(context, listen: false)
                .fetchMeasurements(),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<MeasurementController>(
                    builder: (ctx, measurements, child) {
                    if (measurements.items.isEmpty) {
                      return child ??
                          Center(
                            child: Text(
                              'no_measurements_text'.i18n(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                    } else {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: measurements.items.length,
                          itemBuilder: (ctx, i) => ListTile(
                              title: Text(measurements.items[i].value),
                              subtitle: Text(measurements.items[i].description),
                              trailing: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Theme.of(context).focusColor,
                                    ),
                                    onPressed: () {
                                      _editItem(measurements.items[i]);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _deleteItem(measurements.items[i].id);
                                    },
                                  ),
                                ],
                              )),
                        ),
                      );
                    }
                  }),
          ),
        ),
      ),
    );
  }
}
