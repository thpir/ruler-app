import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/database_provider.dart';
import '../models/measurement.dart';

class MeasurementListScreen extends StatefulWidget {
  const MeasurementListScreen({super.key});

  @override
  State<MeasurementListScreen> createState() => _MeasurementListScreenState();
}

class _MeasurementListScreenState extends State<MeasurementListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Measurement History',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold,fontSize: 20)
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<DatabaseProvider>(context, listen: false)
            .fetchMeasurements(),
        builder: (ctx, snapshot) => snapshot.connectionState == 
            ConnectionState.waiting 
          ? const Center(
                  child: CircularProgressIndicator(),
                )
          : Consumer<DatabaseProvider>(
            builder: (ctx, measurements, ch) => 
              ListView.builder(
                  itemCount: measurements.items.length,
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text(measurements.items[i].value.toString()),
                    subtitle: Text(measurements.items[i].description),
                  ),
                
            ), 
            child: Center(
                child: Text(
                  'No measurements yet...', 
                  style: Theme.of(context).textTheme.bodyText2,
                ),
            ),
        ),
      ),
    );
  }
}