import 'package:flutter/material.dart';

class WaterIntake {
  const WaterIntake({
    @required this.todaysTotalWaterIntake,
    @required this.todaysWaterIntake,
    @required this.allWaterIntake,
  });

  final int todaysTotalWaterIntake;
  final List<Map<String, dynamic>> todaysWaterIntake;
  final List<Map<String, dynamic>> allWaterIntake;
}
