import 'package:flutter/material.dart';

class WaterIntake {
  const WaterIntake({
    @required this.todaysTotalIntakes,
    @required this.todaysIntakes,
  });

  final int todaysTotalIntakes;
  final List<Map<String, dynamic>> todaysIntakes;
}
