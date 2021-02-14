import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

const availableCups = {
  'Cup #1': 250.0,
  'Cup #2': 300.0,
  'Cup #3': 500.0,
};

class WaterIntakeNotifier extends StateNotifier<WaterIntakeModel> {
  WaterIntakeNotifier() : super(_initialState);

  static final _initialState = WaterIntakeModel(
    today: DateTime.now(),
    now: TimeOfDay.now(),
    cup: availableCups['Cup #1'],
    totalIntake: 0,
  );

  void addIntake() {
    state = WaterIntakeModel(
      today: state.today,
      now: state.now,
      cup: state.cup,
      totalIntake: state.totalIntake + state.cup,
    );
  }
}

class WaterIntakeModel {
  final DateTime today;
  final TimeOfDay now;
  final double cup;
  final double totalIntake;

  WaterIntakeModel({
    this.today,
    this.now,
    this.cup,
    this.totalIntake,
  });
}
