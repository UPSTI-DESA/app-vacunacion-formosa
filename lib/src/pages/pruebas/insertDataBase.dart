// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../helpers/database_helper.dart';

class PruebaInsert extends StatelessWidget {
  const PruebaInsert({Key? key}) : super(key: key);
  static const String nombreRuta = 'PruebaInsert';

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('query'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnIdVacu: '123',
      DatabaseHelper.columnDesc: 'SPUTNIK'
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnIdVacu: '123',
      DatabaseHelper.columnDesc: 'AFFS'
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }
}
