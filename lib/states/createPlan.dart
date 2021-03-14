import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/createPlan.dart';

class CreatePlanNotifier extends StateNotifier<CreatePlan> {
  CreatePlanNotifier() : super(_initialValue);

  static final _initialValue = CreatePlan(
    selectedGender: Gender.none,
    isGenderNone: false,
    birthdayFormKey: GlobalKey<FormState>(),
    birthdayTextController: TextEditingController(),
    wakeupTimeFormKey: GlobalKey<FormState>(),
    wakeupTimeTextController: TextEditingController(),
    bedtimeFormKey: GlobalKey<FormState>(),
    bedtimeTextController: TextEditingController(),
    dailyGoalFormKey: GlobalKey<FormState>(),
    dailyGoalTextController: TextEditingController(),
    selectedLiquidMeasurement: LiquidMeasurement.ml,
  );

  void setGender(Gender gender) {
    state = CreatePlan(
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
    );
  }

  void isGenderHasError(bool value) {
    state = CreatePlan(
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
    );
  }

  void setLiquideMeasurement(LiquidMeasurement liquidMeasurement) {
    state = CreatePlan(
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
    );
  }

  void clearCreatePlan() {
    state = CreatePlan(
      selectedGender: Gender.none,
      isGenderNone: false,
      birthdayFormKey: GlobalKey<FormState>(),
      birthdayTextController: TextEditingController(),
      wakeupTimeFormKey: GlobalKey<FormState>(),
      wakeupTimeTextController: TextEditingController(),
      bedtimeFormKey: GlobalKey<FormState>(),
      bedtimeTextController: TextEditingController(),
      dailyGoalFormKey: GlobalKey<FormState>(),
      dailyGoalTextController: TextEditingController(),
      selectedLiquidMeasurement: LiquidMeasurement.ml,
    );
  }
}

final createPlanProvider =
    StateNotifierProvider<CreatePlanNotifier>((ref) => CreatePlanNotifier());

final _selectedGenderState = Provider<Gender>((ref) {
  return ref.watch(createPlanProvider.state).selectedGender;
});

final selectedGenderProvider = Provider<Gender>((ref) {
  return ref.watch(_selectedGenderState);
});

final _isGenderNoneState = Provider<bool>((ref) {
  return ref.watch(createPlanProvider.state).isGenderNone;
});

final isGenderNoneProvider = Provider<bool>((ref) {
  return ref.watch(_isGenderNoneState);
});

final _birthdayFormKeyState = Provider<GlobalKey<FormState>>((ref) {
  return ref.watch(createPlanProvider.state).birthdayFormKey;
});

final birthdayFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return ref.watch(_birthdayFormKeyState);
});

final _birthdayTextControllerState = Provider<TextEditingController>((ref) {
  return ref.watch(createPlanProvider.state).birthdayTextController;
});

final birthdayTextControllerProvider = Provider<TextEditingController>((ref) {
  return ref.watch(_birthdayTextControllerState);
});

final _wakeupTimeFormKeyState = Provider<GlobalKey<FormState>>((ref) {
  return ref.watch(createPlanProvider.state).wakeupTimeFormKey;
});

final wakeupTimeFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return ref.watch(_wakeupTimeFormKeyState);
});

final _wakeupTimeTextControllerState = Provider<TextEditingController>((ref) {
  return ref.watch(createPlanProvider.state).wakeupTimeTextController;
});

final wakeupTimeTextControllerProvider = Provider<TextEditingController>((ref) {
  return ref.watch(_wakeupTimeTextControllerState);
});

final _bedtimeFormKeyState = Provider<GlobalKey<FormState>>((ref) {
  return ref.watch(createPlanProvider.state).bedtimeFormKey;
});

final bedtimeFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return ref.watch(_bedtimeFormKeyState);
});

final _bedtimeTextControllerState = Provider<TextEditingController>((ref) {
  return ref.watch(createPlanProvider.state).bedtimeTextController;
});

final bedtimeTextControllerProvider = Provider<TextEditingController>((ref) {
  return ref.watch(_bedtimeTextControllerState);
});

final _dailyGoalFormKeyState = Provider<GlobalKey<FormState>>((ref) {
  return ref.watch(createPlanProvider.state).dailyGoalFormKey;
});

final dailyGoalFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return ref.watch(_dailyGoalFormKeyState);
});

final _dailyGoalTextControllerState = Provider<TextEditingController>((ref) {
  return ref.watch(createPlanProvider.state).dailyGoalTextController;
});

final dailyGoalTextControllerProvider = Provider<TextEditingController>((ref) {
  return ref.watch(_dailyGoalTextControllerState);
});

final _selectedLiquidMeasurementState = Provider<LiquidMeasurement>((ref) {
  return ref.watch(createPlanProvider.state).selectedLiquidMeasurement;
});

final selectedLiquidMeasurementProvider = Provider<LiquidMeasurement>((ref) {
  return ref.watch(_selectedLiquidMeasurementState);
});
