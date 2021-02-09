import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'database_helper.dart';

enum Gender {
  male,
  female,
}

class UserInformationNotifier extends StateNotifier<UserInformationModel> {
  UserInformationNotifier() : super(_initialState);

  static final _initialState = UserInformationModel(
    gender: Gender.male,
    dateOfBirth: DateTime.now(),
    age: 0,
    wakeUpTime: TimeOfDay(
      hour: 8,
      minute: 30,
    ),
    bedtime: TimeOfDay(
      hour: 22,
      minute: 0,
    ),
    waterIntakeGoal: 0,
  );

  void selectGender(Gender gender) {
    state = UserInformationModel(
      gender: gender,
      dateOfBirth: state.dateOfBirth,
      age: state.age,
      wakeUpTime: state.wakeUpTime,
      bedtime: state.bedtime,
      waterIntakeGoal: state.waterIntakeGoal,
    );
  }

  void selectDateOfBirth(DateTime date) {
    final age = getAge(date);

    state = UserInformationModel(
      gender: state.gender,
      dateOfBirth: date,
      age: age,
      wakeUpTime: state.wakeUpTime,
      bedtime: state.bedtime,
      waterIntakeGoal: state.waterIntakeGoal,
    );
  }

  int getAge(DateTime date) {
    final today = DateTime.now();
    var age = today.year - date.year;

    if (today.year < date.year) age--;

    return age;
  }

  void selectWakeUpTime(TimeOfDay time) {
    state = UserInformationModel(
      gender: state.gender,
      dateOfBirth: state.dateOfBirth,
      age: state.age,
      wakeUpTime: time,
      bedtime: state.bedtime,
      waterIntakeGoal: state.waterIntakeGoal,
    );
  }

  void selectBedtime(TimeOfDay time) {
    state = UserInformationModel(
      gender: state.gender,
      dateOfBirth: state.dateOfBirth,
      age: state.age,
      wakeUpTime: state.wakeUpTime,
      bedtime: time,
      waterIntakeGoal: state.waterIntakeGoal,
    );
  }

  void setWaterIntakeGoal() {
    final waterIntakeGoal = getWaterIntakeGoal(
      gender: state.gender,
      age: state.age,
    );

    state = UserInformationModel(
      gender: state.gender,
      dateOfBirth: state.dateOfBirth,
      age: state.age,
      wakeUpTime: state.wakeUpTime,
      bedtime: state.bedtime,
      waterIntakeGoal: waterIntakeGoal,
    );
  }

  double getWaterIntakeGoal({Gender gender, int age}) {
    double waterIntakeGoal;

    switch (gender) {
      case Gender.male:
        {
          if (age == 0) {
            waterIntakeGoal = 0.8;
          } else if (age <= 3) {
            waterIntakeGoal = 1.3;
          } else if (age <= 8) {
            waterIntakeGoal = 1.7;
          } else if (age <= 13) {
            waterIntakeGoal = 2.4;
          } else if (age <= 18) {
            waterIntakeGoal = 3.3;
          } else if (age >= 19) {
            waterIntakeGoal = 3.7;
          }
        }
        break;
      case Gender.female:
        {
          if (age == 0) {
            waterIntakeGoal = 0.8;
          } else if (state.age <= 3) {
            waterIntakeGoal = 1.3;
          } else if (age <= 8) {
            waterIntakeGoal = 1.7;
          } else if (age <= 13) {
            waterIntakeGoal = 2.1;
          } else if (age <= 18) {
            waterIntakeGoal = 2.3;
          } else if (age >= 19) {
            waterIntakeGoal = 2.7;
          }
        }
        break;
    }

    return waterIntakeGoal;
  }

  final dbHelper = DatabaseHelper.instance;

  void insertUserInformation() async {
    final gender = state.gender.toString().split('.').last;
    final dateOfBirth = DateFormat.yMd().format(state.dateOfBirth);

    final nowDate = DateTime.now();
    final dateWakeUpTime = DateTime(nowDate.year, nowDate.month, nowDate.day,
        state.wakeUpTime.hour, state.wakeUpTime.minute);
    final wakeUpTime = DateFormat.jm().format(dateWakeUpTime);
    final dateBedtime = DateTime(nowDate.year, nowDate.month, nowDate.day,
        state.bedtime.hour, state.bedtime.minute);
    final bedtime = DateFormat.jm().format(dateBedtime);

    final row = <String, dynamic>{
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnGender: gender,
      DatabaseHelper.columnDateOfBirth: dateOfBirth,
      DatabaseHelper.columnAge: state.age,
      DatabaseHelper.columnWakeUpTime: wakeUpTime,
      DatabaseHelper.columnBedtime: bedtime,
      DatabaseHelper.columnWaterIntakeGoal: state.waterIntakeGoal,
    };

    final databaseInfo = await dbHelper.insert(row);
    print('Inserted row: $databaseInfo');
  }

  void queryAllRows() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }
}

class UserInformationModel {
  final Gender gender;
  final DateTime dateOfBirth;
  final int age;
  final TimeOfDay wakeUpTime;
  final TimeOfDay bedtime;
  final double waterIntakeGoal;

  const UserInformationModel({
    this.gender,
    this.dateOfBirth,
    this.age,
    this.wakeUpTime,
    this.bedtime,
    this.waterIntakeGoal,
  });
}
