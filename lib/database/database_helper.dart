import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseAssetName = 'goldfish.db';
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();

    return _database;
  }

  Future<Database> _initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, 'MyDatabase.db');

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      var data =
          await rootBundle.load(join('assets', 'database', _databaseAssetName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, version: _databaseVersion);
  }

  Future<int> getTodaysTotalWaterIntake() async {
    var db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('''
        SELECT SUM (amount) FROM waterIntake WHERE 
        strftime('%d-%m-%Y', date) = 
        strftime('%d-%m-%Y', 'now', 'localtime', '-2 day');
      '''),
    );
  }

  Future<List<Map<String, dynamic>>> getTodaysWaterIntake() async {
    var db = await instance.database;
    return await db.rawQuery('''
      SELECT waterIntake.amount, waterIntake.measurement, drinkType.drinkTypes, 
      tileColor.tileColors, waterIntake.date FROM waterIntake, drinkType, 
      tileColor WHERE waterIntake.drinkTypes = drinkType.drinkTypes AND 
      waterIntake.tileColors = tileColor.tileColors AND strftime('%d-%m-%Y', 
      waterIntake.date) = strftime('%d-%m-%Y', 'now', 'localtime', '-2 day');
    ''');
  }

  /// Get all the information of the selected `cup`
  Future<List<Map<String, dynamic>>> getSelectedCup() async {
    final db = await instance.database;

    return await db.rawQuery(
      'SELECT * FROM cup WHERE isActive = ?',
      ['true'],
    );
  }

  /// Get all the information of `cup` table
  Future<List<Map<String, dynamic>>> getAllCup() async {
    final db = await instance.database;

    return await db.rawQuery('SELECT * FROM cup');
  }

  /// Set all the `cup` tables' `isActive` column to `false`
  ///
  /// This will be called before updating the new selected `cup`
  Future<void> _setAllCupIsActiveFalse() async {
    final db = await instance.database;

    await db.rawUpdate(
      'UPDATE cup SET isActive = ?',
      ['false'],
    );
  }

  /// Set the selected `cup` tables' `isActive` column to `true`
  ///
  /// This will call the `setAllCupIsActiveFalse` function, then update the new
  /// selected `cup` tables' `isActive` column.
  Future<void> setSelectedCup(int cupID) async {
    final db = await instance.database;

    await _setAllCupIsActiveFalse();

    await db.rawUpdate(
      'UPDATE cup SET isActive = ? WHERE cupID = ?',
      ['true', '$cupID'],
    );
  }

  /// Get all the information of the selected `drinkType`
  Future<List<Map<String, dynamic>>> getSelectedDrinkType() async {
    final db = await instance.database;

    return await db.rawQuery(
      'SELECT * FROM drinkType WHERE isActive = ?',
      ['true'],
    );
  }

  /// Get all the information of `drinkType` table
  Future<List<Map<String, dynamic>>> getAllDrinkType() async {
    final db = await instance.database;

    return await db.rawQuery('SELECT * FROM drinkType');
  }

  /// Set all the `drinkType` tables' `isActive` column to `false`
  ///
  /// This will be called before updating the new selected `drinkType`
  Future<void> _setAllDrinkTypeIsActiveFalse() async {
    final db = await instance.database;

    await db.rawUpdate(
      'UPDATE drinkType SET isActive = ?',
      ['false'],
    );
  }

  /// Set the selected `drinkType` tables' `isActive` column to `true`
  ///
  /// This will call the `_setAllDrinkTypeIsActiveFalse` function, then update
  /// the new selected `drinkType` tables' `isActive` column.
  Future<void> setSelectedDrinkType(String drinkType) async {
    final db = await instance.database;

    await _setAllDrinkTypeIsActiveFalse();

    await db.rawUpdate(
      'UPDATE drinkType SET isActive = ? WHERE drinkTypes = ?',
      ['true', '$drinkType'],
    );
  }
}
