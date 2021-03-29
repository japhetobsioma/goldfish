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
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'MyDatabase.db');

    final exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      final data =
          await rootBundle.load(join('assets', 'database', _databaseAssetName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, version: _databaseVersion);
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

  /// Get all the information of the selected `tileColor`
  Future<List<Map<String, dynamic>>> getSelectedTileColor() async {
    final db = await instance.database;

    return await db.rawQuery(
      'SELECT * FROM tileColor WHERE isActive = ?',
      ['true'],
    );
  }

  /// Get all the information of `tileColor` table
  Future<List<Map<String, dynamic>>> getAllTileColor() async {
    final db = await instance.database;

    return await db.rawQuery('SELECT * FROM tileColor');
  }

  /// Set all the `tileColor` tables' `isActive` column to `false`
  ///
  /// This will be called before updating the new selected `tileColor`
  Future<void> _setAllTileColorIsActiveFalse() async {
    final db = await instance.database;

    await db.rawUpdate(
      'UPDATE tileColor SET isActive = ?',
      ['false'],
    );
  }

  /// Set the selected `tileColor` tables' `isActive` column to `true`
  ///
  /// This will call the `_setAllTileColorIsActiveFalse` function, then update
  /// the new selected `tileColor` tables' `isActive` column.
  Future<void> setSelectedTileColor(String tileColor) async {
    final db = await instance.database;

    await _setAllTileColorIsActiveFalse();

    await db.rawUpdate(
      'UPDATE tileColor SET isActive = ? WHERE tileColors = ?',
      ['true', '$tileColor'],
    );
  }

  // Get all todays total water intake
  Future<int> getTodaysTotalWaterIntake() async {
    var db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT SUM (amount) FROM waterIntake WHERE strftime(?, date) = '
        'strftime(?, ?, ?)',
        ['%d-%m-%Y', '%d-%m-%Y', 'now', 'localtime'],
      ),
    );
  }

  /// Get all todays water intake
  Future<List<Map<String, dynamic>>> getTodaysWaterIntake() async {
    final db = await instance.database;
    return await db.rawQuery(
      'SELECT waterIntake.amount, waterIntake.measurement, '
      'drinkType.drinkTypes, tileColor.tileColors, waterIntake.date FROM '
      'waterIntake, drinkType, tileColor WHERE waterIntake.drinkTypes = '
      'drinkType.drinkTypes AND waterIntake.tileColors = tileColor.tileColors '
      'AND strftime(?, waterIntake.date) = strftime(?, ?, ?) ORDER BY date '
      'DESC',
      ['%d-%m-%Y', '%d-%m-%Y', 'now', 'localtime'],
    );
  }

  /// Insert water intake to `waterIntake` table
  Future<void> insertWaterIntake(
    int amount,
    String measurement,
    String drinkType,
    String tileColor,
  ) async {
    final db = await instance.database;

    return await db.rawQuery(
      'INSERT INTO waterIntake (amount, measurement, date, drinkTypes, '
      'tileColors) VALUES (?, ?, datetime(?, ?), ?, ?)',
      [
        '$amount',
        '$measurement',
        'now',
        'localtime',
        '$drinkType',
        '$tileColor'
      ],
    );
  }
}
