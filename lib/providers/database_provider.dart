import 'package:flutter/material.dart';
import 'package:ruler_app/helpers/db_helper.dart';

import '../models/measurement.dart';

class DatabaseProvider with ChangeNotifier {
  List<Measurement> _items = [];

  List<Measurement> get items {
    return [..._items]; // Getter to return a COPY of the original _items list
  }

  // Method to add a measurement to the database and update the list of measurements
  Future<void> addMeasurement(String measurement, String description) async {
    final newMeasurement = Measurement(
        id: DateTime.now().toString(),
        value: measurement,
        description: description);
    _items.add(newMeasurement);
    notifyListeners();
    await DBHelper.insert('measurements', {
      'id': newMeasurement.id,
      'value': newMeasurement.value,
      'description': newMeasurement.description,
    });
  }

  // Method to delete a measurement from the database and update the list of measurements
  Future<void> deleteMeasurement(String id) async {
    _items.removeWhere((measurement) => measurement.id == id);
    notifyListeners();
    DBHelper.delete('measurements', id);
  }

  // A method to display all the measurements that are saved to the database in a list
  Future<void> fetchMeasurements() async {
    final measurementsList = await DBHelper.getData('measurements');
    _items = measurementsList
        .map((item) => Measurement(
            id: item['id'],
            value: item['value'],
            description: item['description']))
        .toList();
    notifyListeners();
  }
}
