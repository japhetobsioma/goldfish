import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'appDatabase.dart';
import '../models/createPlan.dart';
import '../common/helpers.dart';

class CreatePlanNotifier extends StateNotifier<CreatePlan> {
  CreatePlanNotifier(this.providerReference) : super(_initialValue);

  final ProviderReference providerReference;

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
    dailyGoalTextController: TextEditingController(text: '0'),
    selectedLiquidMeasurement: LiquidMeasurement.ml,
    isUsingRecommendedDailyGoal: true,
  );

  /// Set selected gender of create plan state.
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
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }

  /// Set gender to value none of create plan state.
  void setGenderNone(bool value) {
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
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }

  /// Set selected liquid measurement of create plan state.
  void setLiquidMeasurement(LiquidMeasurement liquidMeasurement) {
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
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }

  /// Calculate daily goal based on gender and age.
  ///
  /// Reference: https://www.who.int/water_sanitation_health/dwq/nutwaterrequir.pdf
  ///
  /// This validate the gender and birthday first before calculating.
  void calculateDailyGoal() {
    final gender = state.selectedGender;
    final birthday = state.birthdayTextController.text;
    final liquidMeasurement = state.selectedLiquidMeasurement;
    int dailyGoal;

    if (!genderToString(gender).contains('None') && birthday.isNotEmpty) {
      if (isDateFormatValid(birthday) && isMinimumAge(birthday)) {
        final age = getAge(stringToDate(birthday));
        dailyGoal = getDailyGoal(gender, age, liquidMeasurement);

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
          dailyGoalTextController:
              TextEditingController(text: dailyGoal.toString()),
          selectedLiquidMeasurement: state.selectedLiquidMeasurement,
          isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
        );
      }
    }
  }

  /// Convert daily goal based on selected liquid measurement.
  void convertDailyGoal() {
    final liquidMeasurement = state.selectedLiquidMeasurement;
    final dailyGoalTextController =
        double.tryParse(state.dailyGoalTextController.text);
    int dailyGoal;

    switch (liquidMeasurement) {
      case LiquidMeasurement.ml:
        dailyGoal = fluidOunceToMilliliters(dailyGoalTextController);
        break;
      case LiquidMeasurement.fl_oz:
        dailyGoal = millilitersToFluidOunce(dailyGoalTextController);
        break;
    }

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
      dailyGoalTextController:
          TextEditingController(text: dailyGoal.toString()),
      selectedLiquidMeasurement: state.selectedLiquidMeasurement,
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }

  /// Set daily goal of create plan state.
  void setDailyGoal(String value) {
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
      dailyGoalTextController: TextEditingController(text: value),
      selectedLiquidMeasurement: state.selectedLiquidMeasurement,
      isUsingRecommendedDailyGoal: state.isUsingRecommendedDailyGoal,
    );
  }

  /// Set using recommended daily goal field of create plan state.
  void setUsingRecommendedDailyGoal(bool value) {
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
      selectedLiquidMeasurement: state.selectedLiquidMeasurement,
      isUsingRecommendedDailyGoal: value,
    );
  }

  /// Reset all states of create plan state.
  void clearAllFields() {
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
      dailyGoalTextController: TextEditingController(text: '0'),
      selectedLiquidMeasurement: LiquidMeasurement.ml,
      isUsingRecommendedDailyGoal: true,
    );
  }

  /// Get all the data from create plan state, then insert it to database.
  void createHydrationPlan() async {
    await providerReference.read(appDatabaseProvider.state).createHydrationPlan(
          genderToString(state.selectedGender),
          state.birthdayTextController.text,
          state.wakeupTimeTextController.text,
          state.bedtimeTextController.text,
          int.tryParse(state.dailyGoalTextController.text),
          liquidMeasurementToString(state.selectedLiquidMeasurement),
          state.isUsingRecommendedDailyGoal == true ? 1 : 0,
          dateToString(DateTime.now()),
        );
  }

  /// Print hydration plan from the database.
  void printHydrationPlan() async {
    final hydrationPlan = await providerReference
        .read(appDatabaseProvider.state)
        .readHydrationPlan()
        .get();

    hydrationPlan.forEach((element) {
      print(element.gender);
      print(element.birthday);
      print(element.wakeupTime);
      print(element.bedtime);
      print(element.dailyGoal);
      print(element.liquidMeasurement);
      print(element.isUsingRecommendedDailyGoal == 1 ? true : false);
      print(element.joinedDate);
    });
  }

  void deleteHydrationPlan() async {
    await providerReference
        .read(appDatabaseProvider.state)
        .deleteHydrationPlan();
  }
}

final createPlanProvider =
    StateNotifierProvider<CreatePlanNotifier>((ref) => CreatePlanNotifier(ref));

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

final _isUsingRecommendedDailyGoalState = Provider<bool>((ref) {
  return ref.watch(createPlanProvider.state).isUsingRecommendedDailyGoal;
});

final isUsingRecommendedDailyGoalProvider = Provider<bool>((ref) {
  return ref.watch(_isUsingRecommendedDailyGoalState);
});
