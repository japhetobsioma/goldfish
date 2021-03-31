import 'package:flutter/material.dart';

enum Gender {
  Male,
  Female,
  None,
}
enum LiquidMeasurement {
  Milliliter,
  FluidOunce,
}

class UserInfo {
  const UserInfo({
    @required this.gender,
    @required this.birthday,
    @required this.wakeupTime,
    @required this.bedtime,
    @required this.dailyGoal,
    @required this.liquidMeasurement,
    @required this.isUsingRecommendedDailyGoal,
    @required this.joinedDate,
  });

  final Gender gender;
  final DateTime birthday;
  final TimeOfDay wakeupTime;
  final TimeOfDay bedtime;
  final int dailyGoal;
  final LiquidMeasurement liquidMeasurement;
  final bool isUsingRecommendedDailyGoal;
  final DateTime joinedDate;
}
