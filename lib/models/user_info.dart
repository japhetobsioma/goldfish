import 'package:flutter/material.dart';

enum Gender { Male, Female, None }
enum LiquidMeasurement { Milliliter, FluidOunce }

class UserInfo {
  const UserInfo({
    this.gender,
    this.birthday,
    this.wakeupTime,
    this.bedtime,
    this.dailyGoal,
    this.liquidMeasurement,
    this.isUsingRecommendedDailyGoal,
    this.joinedDate,
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
