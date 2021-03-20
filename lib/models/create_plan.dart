import 'package:flutter/material.dart';

import 'user_info.dart';

class CreatePlanForm {
  const CreatePlanForm({
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
    this.isUsingRecommendedDailyGoal,
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
  final bool isUsingRecommendedDailyGoal;
}
