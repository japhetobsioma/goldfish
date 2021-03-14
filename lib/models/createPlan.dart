import 'package:flutter/material.dart';

enum Gender { male, female, none }

enum LiquidMeasurement { ml, fl_oz }

class CreatePlan {
  const CreatePlan({
    this.selectedGender,
    this.isGenderNone,
    this.birthdayFormKey,
    this.birthdayTextController,
    this.wakeupTimeFormKey,
    this.wakeupTimeTextController,
    this.bedtimeFormKey,
    this.bedtimeTextController,
    this.dailyGoalFormKey,
    this.dailyGoalTextController,
    this.selectedLiquidMeasurement,
  });

  final Gender selectedGender;
  final bool isGenderNone;
  final GlobalKey<FormState> birthdayFormKey;
  final TextEditingController birthdayTextController;
  final GlobalKey<FormState> wakeupTimeFormKey;
  final TextEditingController wakeupTimeTextController;
  final GlobalKey<FormState> bedtimeFormKey;
  final TextEditingController bedtimeTextController;
  final GlobalKey<FormState> dailyGoalFormKey;
  final TextEditingController dailyGoalTextController;
  final LiquidMeasurement selectedLiquidMeasurement;
}
