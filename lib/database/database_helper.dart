import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../common/helpers.dart';
import '../models/user_info.dart';

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
      'SELECT waterIntake.amount, waterIntake.measurement,'
      'waterIntake.waterIntakeID, drinkType.drinkTypes, tileColor.tileColors, '
      'waterIntake.date FROM waterIntake, drinkType, tileColor WHERE '
      'waterIntake.drinkTypes = drinkType.drinkTypes AND '
      'waterIntake.tileColors = tileColor.tileColors AND '
      'strftime(?, waterIntake.date) = strftime(?, ?, ?) ORDER BY date DESC',
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

    await db.rawInsert(
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

  Future<void> updateWaterIntakeCup({
    @required int amount,
    @required String measurement,
    @required int waterIntakeID,
  }) async {
    final db = await instance.database;

    await db.rawUpdate('''
      UPDATE 
        waterIntake 
      SET 
        amount = ?, 
        measurement = ?
      WHERE 
        waterIntakeID = ?
    ''', [
      '$amount',
      '$measurement',
      '$waterIntakeID',
    ]);
  }

  Future<void> updateWaterIntakeMeasurement({
    @required String measurement,
    @required int waterIntakeID,
  }) async {
    final db = await instance.database;

    await db.rawUpdate('''
      UPDATE 
        waterIntake 
      SET 
        measurement = ?
      WHERE 
        waterIntakeID = ?
    ''', [
      '$measurement',
      '$waterIntakeID',
    ]);
  }

  Future<void> updateWaterIntakeDate({
    @required String date,
    @required int waterIntakeID,
  }) async {
    final db = await instance.database;

    await db.rawUpdate('''
      UPDATE 
        waterIntake 
      SET 
        date = ?
      WHERE 
        waterIntakeID = ?
    ''', [
      '$date',
      '$waterIntakeID',
    ]);
  }

  Future<void> updateWaterIntakeDrinkTypes({
    @required String drinkTypes,
    @required int waterIntakeID,
  }) async {
    final db = await instance.database;

    await db.rawUpdate('''
      UPDATE 
        waterIntake 
      SET 
        drinkTypes = ? 
      WHERE 
        waterIntakeID = ?
    ''', [
      '$drinkTypes',
      '$waterIntakeID',
    ]);
  }

  Future<void> updateWaterIntakeTileColors({
    @required String tileColors,
    @required int waterIntakeID,
  }) async {
    final db = await instance.database;

    await db.rawUpdate('''
      UPDATE 
        waterIntake 
      SET 
        tileColors = ? 
      WHERE 
        waterIntakeID = ?
    ''', [
      '$tileColors',
      '$waterIntakeID',
    ]);
  }

  Future<void> deleteWaterIntake({@required int waterIntakeID}) async {
    final db = await instance.database;

    await db.rawDelete('''
      DELETE FROM 
        waterIntake 
      WHERE 
        waterIntakeID = ?
    ''', ['$waterIntakeID']);
  }

  Future<void> createHydrationPlan({
    @required Gender gender,
    @required DateTime birthday,
    @required TimeOfDay wakeupTime,
    @required TimeOfDay bedtime,
    @required int dailyGoal,
    @required LiquidMeasurement liquidMeasurement,
    @required bool isUsingRecommendedDailyGoal,
    @required DateTime joinedDate,
  }) async {
    assert(gender != null);
    assert(birthday != null);
    assert(wakeupTime != null);
    assert(bedtime != null);
    assert(dailyGoal != null);
    assert(isUsingRecommendedDailyGoal != null);
    assert(liquidMeasurement != null);

    final db = await instance.database;

    await db.rawInsert('''
      INSERT INTO hydrationPlan (
        gender, birthday, wakeupTime, bedtime, 
        dailyGoal, liquidMeasurement, isUsingRecommendedDailyGoal, 
        joinedDate
      ) 
      VALUES 
        (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      '${gender.nameLowerCase}',
      '${birthday.toString()}',
      '${wakeupTime.toDateTimeTypeString}',
      '${bedtime.toDateTimeTypeString}',
      '$dailyGoal',
      '${liquidMeasurement.description}',
      '${isUsingRecommendedDailyGoal.toString()}',
      '${joinedDate.toString()}',
    ]);
  }

  Future<List<Map<String, dynamic>>> readHydrationPlan() async {
    final db = await instance.database;

    return await db.rawQuery('''
      SELECT 
        gender, 
        birthday, 
        wakeupTime, 
        bedtime, 
        dailyGoal, 
        liquidMeasurement, 
        isUsingRecommendedDailyGoal, 
        joinedDate 
      FROM 
        hydrationPlan 
      ORDER BY 
        id DESC 
      LIMIT 
        1
    ''');
  }

  Future<void> deleteHydrationPlan() async {
    final db = await instance.database;

    await db.rawDelete('''
      DELETE FROM 
        hydrationPlan
    ''');
  }

  Future<List<Map<String, dynamic>>> getCompletionData() async {
    final db = await instance.database;

    return await db.rawQuery('''
      SELECT 
        currentDate, 
        isCompleted 
      FROM 
        Completion
    ''');
  }

  Future<List<Map<String, dynamic>>> getMostDrinkTypes() async {
    final db = await instance.database;

    return await db.rawQuery('''
      SELECT 
        drinkTypes 
      FROM 
        waterIntake 
      GROUP BY 
        drinkTypes 
      ORDER BY 
        COUNT(drinkTypes) DESC,
        date ASC
    ''');
  }

  /// Return a list of completion tables `isCompleted` column.
  Future<List<Map<String, dynamic>>> getCompletionIsCompleted() async {
    final db = await instance.database;

    return await db.rawQuery('''
      SELECT 
        isCompleted 
      FROM 
        Completion
    ''');
  }

  Future<void> setTodaysCompletionDate() async {
    final db = await instance.database;

    await db.rawInsert('''
      INSERT INTO Completion (currentDate, isCompleted) 
      VALUES 
        (date('now', 'localtime'), 0)
    ''');
  }

  Future<List<Map<String, dynamic>>> getCompletionDates() async {
    final db = await instance.database;

    return await db.rawQuery('''
      SELECT 
        currentDate
      FROM 
        Completion
    ''');
  }

  Future<void> setCompletionDates(String query) async {
    final db = await instance.database;

    await db.rawInsert('''
      INSERT INTO Completion (currentDate, isCompleted) 
      VALUES 
        $query
    ''');
  }

  Future<void> updateCompletionStatus(bool completionStatus) async {
    final db = await instance.database;

    final isCompleted = completionStatus.toInt;

    await db.rawUpdate('''
      UPDATE 
        Completion 
      SET 
        isCompleted = $isCompleted 
      WHERE 
        strftime('%d-%m-%Y', currentDate) = 
        strftime('%d-%m-%Y', 'now', 'localtime')
    ''');
  }

  Future<List<Map<String, dynamic>>> getAllWaterIntakes() async {
    final db = await instance.database;

    return await db.rawQuery('''
      SELECT 
        SUM(amount), 
        date 
      FROM 
        waterIntake 
      GROUP BY 
        date
    ''');
  }
}
