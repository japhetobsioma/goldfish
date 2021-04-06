import 'package:flutter/material.dart';

enum WeekDays {
  Sunday,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
}

class DailyTotal {
  const DailyTotal({
    @required this.sundayTotal,
    @required this.mondayTotal,
    @required this.tuesdayTotal,
    @required this.wednesdayTotal,
    @required this.thursdayTotal,
    @required this.fridayTotal,
    @required this.saturdayTotal,
    @required this.highestDayTotal,
  });

  final int sundayTotal;
  final int mondayTotal;
  final int tuesdayTotal;
  final int wednesdayTotal;
  final int thursdayTotal;
  final int fridayTotal;
  final int saturdayTotal;
  final int highestDayTotal;
}
