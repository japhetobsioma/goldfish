import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Gender {
  male,
  female,
}

class UserInformationNotifier extends StateNotifier<UserInformationModel> {
  UserInformationNotifier() : super(_initialState);

  static final _initialState = UserInformationModel(
    gender: Gender.male,
    date: DateTime.now(),
    wakeUpTime: TimeOfDay(
      hour: 8,
      minute: 30,
    ),
    bedtime: TimeOfDay(
      hour: 22,
      minute: 0,
    ),
  );

  void selectGender(Gender gender) {
    state = UserInformationModel(
      gender: gender,
      date: state.date,
      wakeUpTime: state.wakeUpTime,
      bedtime: state.bedtime,
    );
  }

  void selectDateOfBirth(DateTime date) {
    state = UserInformationModel(
      gender: state.gender,
      date: date,
      wakeUpTime: state.wakeUpTime,
      bedtime: state.bedtime,
    );
  }

  void selectWakeUpTime(TimeOfDay time) {
    state = UserInformationModel(
      gender: state.gender,
      date: state.date,
      wakeUpTime: time,
      bedtime: state.bedtime,
    );
  }

  void selectBedtime(TimeOfDay time) {
    state = UserInformationModel(
      gender: state.gender,
      date: state.date,
      wakeUpTime: state.wakeUpTime,
      bedtime: time,
    );
  }
}

class UserInformationModel {
  final Gender gender;
  final DateTime date;
  final TimeOfDay wakeUpTime;
  final TimeOfDay bedtime;

  const UserInformationModel({
    this.gender,
    this.date,
    this.wakeUpTime,
    this.bedtime,
  });
}
