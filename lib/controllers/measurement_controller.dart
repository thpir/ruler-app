import 'package:flutter/material.dart';
import 'package:ruler_app/helpers/db_helper.dart';

import '../models/measurement.dart';

class MeasurementController with ChangeNotifier {
  List<Measurement> _items = [];

  List<Measurement> get items {
    return [..._items];
  }

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

  Future<void> updateMeasurement(
      Measurement measurement, String newDescription, String id) async {
    final editedMeasurement = Measurement(
        id: measurement.id,
        value: measurement.value,
        description:
            newDescription
        );
    var index = _items.indexWhere((measurement) => measurement.id == id);
    _items[index] = editedMeasurement;
    notifyListeners();
    await DBHelper.update(
      'measurements',
      id,
      newDescription,
    );
  }

  Future<void> deleteMeasurement(String id) async {
    _items.removeWhere((measurement) => measurement.id == id);
    notifyListeners();
    DBHelper.delete('measurements', id);
  }

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
