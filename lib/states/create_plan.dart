import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/helpers.dart';
import '../models/create_plan.dart';
import '../models/user_info.dart';
import 'user_info.dart';

class CreatePlanFormNotifier extends StateNotifier<CreatePlanForm> {
  CreatePlanFormNotifier(this.read) : super(_initialValue);

  final Reader read;

  static final _initialValue = CreatePlanForm(
    selectedGender: Gender.None,
    isGenderNone: false,
    birthdayFormKey: GlobalKey<FormState>(),
    birthdayTextController: TextEditingController(),
    wakeupTimeFormKey: GlobalKey<FormState>(),
    wakeupTimeTextController: TextEditingController(),
    bedtimeFormKey: GlobalKey<FormState>(),
    bedtimeTextController: TextEditingController(),
    dailyGoalFormKey: GlobalKey<FormState>(),
    dailyGoalTextController: TextEditingController(text: '0'),
    selectedLiquidMeasurement: LiquidMeasurement.Milliliter,
    isUsingRecommendedDailyGoal: true,
  );

  /// Set selected gender of the create plan.
  void setGender(Gender gender) {
    state = CreatePlanForm(
      selectedGender: gender,
      isGenderNone: state.isGenderNone,
      birthdayFormKey: state.birthdayFormKey,
      birthdayTextController: state.birthdayTextController,
      wakeupTimeFormKey: state.wakeupTimeFormKey,
      wakeupTimeTextController: state.wakeupTimeTextController,
      bedtimeFormKey: state.bedtimeFormKey,
      bedtimeTextController: state.bedtimeTextController,
      dailyGoalFormKey: state.dailyGoalFormKey,
      dailyGoalTextController: state.dailyGoalTextController,
      selectedLiquidMeasurement: state.selectedLiquidMeasurement,
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }

  /// Set gender to value none of create plan.
  void setGenderNone(bool value) {
    state = CreatePlanForm(
      selectedGender: state.selectedGender,
      isGenderNone: value,
      birthdayFormKey: state.birthdayFormKey,
      birthdayTextController: state.birthdayTextController,
      wakeupTimeFormKey: state.wakeupTimeFormKey,
      wakeupTimeTextController: state.wakeupTimeTextController,
      bedtimeFormKey: state.bedtimeFormKey,
      bedtimeTextController: state.bedtimeTextController,
      dailyGoalFormKey: state.dailyGoalFormKey,
      dailyGoalTextController: state.dailyGoalTextController,
      selectedLiquidMeasurement: state.selectedLiquidMeasurement,
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }

  /// Set selected liquid measurement of the create plan.
  void setLiquidMeasurement(LiquidMeasurement liquidMeasurement) {
    state = CreatePlanForm(
      selectedGender: state.selectedGender,
      isGenderNone: state.isGenderNone,
      birthdayFormKey: state.birthdayFormKey,
      birthdayTextController: state.birthdayTextController,
      wakeupTimeFormKey: state.wakeupTimeFormKey,
      wakeupTimeTextController: state.wakeupTimeTextController,
      bedtimeFormKey: state.bedtimeFormKey,
      bedtimeTextController: state.bedtimeTextController,
      dailyGoalFormKey: state.dailyGoalFormKey,
      dailyGoalTextController: state.dailyGoalTextController,
      selectedLiquidMeasurement: liquidMeasurement,
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }

  /// Calculate the daily goal based on gender and age.
  ///
  /// Reference:
  /// https://www.who.int/water_sanitation_health/dwq/nutwaterrequir.pdf
  ///
  /// This validate the gender and birthday first before calculating.
  void calculateDailyGoal() {
    final gender = state.selectedGender;
    final birthday = state.birthdayTextController.text;
    final liquidMeasurement = state.selectedLiquidMeasurement;
    int dailyGoal;

    if (gender.isNotNone && birthday.isNotEmpty) {
      if (birthday.dateFormatIsValid && isNotBelowMinimumAge(birthday)) {
        final age = getAge(birthday.toDateTimeFormatted);
        dailyGoal = getDailyGoal(gender, age, liquidMeasurement);

        state = CreatePlanForm(
          selectedGender: state.selectedGender,
          isGenderNone: state.isGenderNone,
          birthdayFormKey: state.birthdayFormKey,
          birthdayTextController: state.birthdayTextController,
          wakeupTimeFormKey: state.wakeupTimeFormKey,
          wakeupTimeTextController: state.wakeupTimeTextController,
          bedtimeFormKey: state.bedtimeFormKey,
          bedtimeTextController: state.bedtimeTextController,
          dailyGoalFormKey: state.dailyGoalFormKey,
          dailyGoalTextController:
              TextEditingController(text: dailyGoal.toString()),
          selectedLiquidMeasurement: state.selectedLiquidMeasurement,
          isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
        );
      }
    }
  }

  /// Convert the daily goal based on the selected liquid measurement.
  void convertDailyGoal() {
    final liquidMeasurement = state.selectedLiquidMeasurement;
    final dailyGoalTextController =
        double.tryParse(state.dailyGoalTextController.text);
    int dailyGoal;

    switch (liquidMeasurement) {
      case LiquidMeasurement.Milliliter:
        dailyGoal = fluidOunceToMilliliters(dailyGoalTextController);
        break;
      case LiquidMeasurement.FluidOunce:
        dailyGoal = millilitersToFluidOunce(dailyGoalTextController);
        break;
    }

    state = CreatePlanForm(
      selectedGender: state.selectedGender,
      isGenderNone: state.isGenderNone,
      birthdayFormKey: state.birthdayFormKey,
      birthdayTextController: state.birthdayTextController,
      wakeupTimeFormKey: state.wakeupTimeFormKey,
      wakeupTimeTextController: state.wakeupTimeTextController,
      bedtimeFormKey: state.bedtimeFormKey,
      bedtimeTextController: state.bedtimeTextController,
      dailyGoalFormKey: state.dailyGoalFormKey,
      dailyGoalTextController:
          TextEditingController(text: dailyGoal.toString()),
      selectedLiquidMeasurement: state.selectedLiquidMeasurement,
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }

  /// Set daily goal of the create plan.
  void setDailyGoal(String value) {
    state = CreatePlanForm(
      selectedGender: state.selectedGender,
      isGenderNone: state.isGenderNone,
      birthdayFormKey: state.birthdayFormKey,
      birthdayTextController: state.birthdayTextController,
      wakeupTimeFormKey: state.wakeupTimeFormKey,
      wakeupTimeTextController: state.wakeupTimeTextController,
      bedtimeFormKey: state.bedtimeFormKey,
      bedtimeTextController: state.bedtimeTextController,
      dailyGoalFormKey: state.dailyGoalFormKey,
      dailyGoalTextController: TextEditingController(text: value),
      selectedLiquidMeasurement: state.selectedLiquidMeasurement,
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }

  /// Set using recommended daily goal field of create plan.
  void setUsingRecommendedDailyGoal(bool value) {
    state = CreatePlanForm(
      selectedGender: state.selectedGender,
      isGenderNone: state.isGenderNone,
      birthdayFormKey: state.birthdayFormKey,
      birthdayTextController: state.birthdayTextController,
      wakeupTimeFormKey: state.wakeupTimeFormKey,
      wakeupTimeTextController: state.wakeupTimeTextController,
      bedtimeFormKey: state.bedtimeFormKey,
      bedtimeTextController: state.bedtimeTextController,
      dailyGoalFormKey: state.dailyGoalFormKey,
      dailyGoalTextController: state.dailyGoalTextController,
      selectedLiquidMeasurement: state.selectedLiquidMeasurement,
      isUsingRecommendedDailyGoal: value,
    );
  }

  /// Reset all states of create plan.
  void clearAllFields() {
    state = CreatePlanForm(
      selectedGender: Gender.None,
      isGenderNone: false,
      birthdayFormKey: GlobalKey<FormState>(),
      birthdayTextController: TextEditingController(),
      wakeupTimeFormKey: GlobalKey<FormState>(),
      wakeupTimeTextController: TextEditingController(),
      bedtimeFormKey: GlobalKey<FormState>(),
      bedtimeTextController: TextEditingController(),
      dailyGoalFormKey: GlobalKey<FormState>(),
      dailyGoalTextController: TextEditingController(text: '0'),
      selectedLiquidMeasurement: LiquidMeasurement.Milliliter,
      isUsingRecommendedDailyGoal: true,
    );
  }

  // static final dbHelper = DatabaseHelper.instance;

  /// Get all the date from create plan form then set it to user info.
  void setUserInfo() async {
    await read(userInfoProvider).createHydrationPlan(
      gender: state.selectedGender,
      birthday: state.birthdayTextController.text,
      wakeupTime: state.wakeupTimeTextController.text,
      bedtime: state.bedtimeTextController.text,
      dailyGoal: state.dailyGoalTextController.text,
      liquidMeasurement: state.selectedLiquidMeasurement,
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }
}

final createPlanFormProvider = StateNotifierProvider<CreatePlanFormNotifier>(
    (ref) => CreatePlanFormNotifier(ref.read));

final _selectedGenderState = Provider<Gender>(
    (ref) => ref.watch(createPlanFormProvider.state).selectedGender);

final selectedGenderProvider =
    Provider<Gender>((ref) => ref.watch(_selectedGenderState));

final _isGenderNoneState = Provider<bool>(
    (ref) => ref.watch(createPlanFormProvider.state).isGenderNone);

final isGenderNoneProvider =
    Provider<bool>((ref) => ref.watch(_isGenderNoneState));

final _birthdayFormKeyState = Provider<GlobalKey<FormState>>(
    (ref) => ref.watch(createPlanFormProvider.state).birthdayFormKey);

final birthdayFormKeyProvider =
    Provider<GlobalKey<FormState>>((ref) => ref.watch(_birthdayFormKeyState));

final _birthdayTextControllerState = Provider<TextEditingController>(
    (ref) => ref.watch(createPlanFormProvider.state).birthdayTextController);

final birthdayTextControllerProvider = Provider<TextEditingController>(
    (ref) => ref.watch(_birthdayTextControllerState));

final _wakeupTimeFormKeyState = Provider<GlobalKey<FormState>>(
    (ref) => ref.watch(createPlanFormProvider.state).wakeupTimeFormKey);

final wakeupTimeFormKeyProvider =
    Provider<GlobalKey<FormState>>((ref) => ref.watch(_wakeupTimeFormKeyState));

final _wakeupTimeTextControllerState = Provider<TextEditingController>(
    (ref) => ref.watch(createPlanFormProvider.state).wakeupTimeTextController);

final wakeupTimeTextControllerProvider = Provider<TextEditingController>(
    (ref) => ref.watch(_wakeupTimeTextControllerState));

final _bedtimeFormKeyState = Provider<GlobalKey<FormState>>(
    (ref) => ref.watch(createPlanFormProvider.state).bedtimeFormKey);

final bedtimeFormKeyProvider =
    Provider<GlobalKey<FormState>>((ref) => ref.watch(_bedtimeFormKeyState));

final _bedtimeTextControllerState = Provider<TextEditingController>(
    (ref) => ref.watch(createPlanFormProvider.state).bedtimeTextController);

final bedtimeTextControllerProvider = Provider<TextEditingController>(
    (ref) => ref.watch(_bedtimeTextControllerState));

final _dailyGoalFormKeyState = Provider<GlobalKey<FormState>>(
    (ref) => ref.watch(createPlanFormProvider.state).dailyGoalFormKey);

final dailyGoalFormKeyProvider =
    Provider<GlobalKey<FormState>>((ref) => ref.watch(_dailyGoalFormKeyState));

final _dailyGoalTextControllerState = Provider<TextEditingController>(
    (ref) => ref.watch(createPlanFormProvider.state).dailyGoalTextController);

final dailyGoalTextControllerProvider = Provider<TextEditingController>(
    (ref) => ref.watch(_dailyGoalTextControllerState));

final _selectedLiquidMeasurementState = Provider<LiquidMeasurement>(
    (ref) => ref.watch(createPlanFormProvider.state).selectedLiquidMeasurement);

final selectedLiquidMeasurementProvider = Provider<LiquidMeasurement>(
    (ref) => ref.watch(_selectedLiquidMeasurementState));

final _isUsingRecommendedDailyGoalState = Provider<bool>((ref) =>
    ref.watch(createPlanFormProvider.state).isUsingRecommendedDailyGoal);

final isUsingRecommendedDailyGoalProvider =
    Provider<bool>((ref) => ref.watch(_isUsingRecommendedDailyGoalState));
