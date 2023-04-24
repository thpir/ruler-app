import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/database_provider.dart';

class MeasurementListScreen extends StatefulWidget {
  static const routeName = '/measurement-list-screen';
  const MeasurementListScreen({super.key});

  @override
  State<MeasurementListScreen> createState() => _MeasurementListScreenState();
}

class _MeasurementListScreenState extends State<MeasurementListScreen> {
  void _deleteItem(String id) {
    Provider.of<DatabaseProvider>(context, listen: false).deleteMeasurement(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurement History',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: FutureBuilder(
        future: Provider.of<DatabaseProvider>(context, listen: false)
            .fetchMeasurements(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<DatabaseProvider>(builder: (ctx, measurements, child) {
                if (measurements.items.isEmpty) {
                  return child ??
                      Center(
                        child: Text(
                          'No measurements yet...',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      );
                } else {
                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: measurements.items.length,
                    itemBuilder: (ctx, i) => ListTile(
                      title: Text(measurements.items[i].value),
                      subtitle: Text(measurements.items[i].description),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _deleteItem(measurements.items[i].id);
                        },
                      ),
                    ),
                  );
                }
              }),
      ),
    );
  }
}
