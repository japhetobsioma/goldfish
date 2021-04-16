import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/helpers.dart';
import '../database/database_helper.dart';
import '../models/hydration_plan.dart';
import '../models/user_info.dart';
import 'user_info.dart';

class HydrationPlanNotifier extends StateNotifier<AsyncValue<HydrationPlan>> {
  HydrationPlanNotifier(this.read) : super(const AsyncLoading()) {
    fetchHydrationPlan();
  }

  final Reader read;

  static final dbHelper = DatabaseHelper.instance;

  Future<void> fetchHydrationPlan() async {
    final hydrationPlanData = await dbHelper.fetchHydrationPlan();

    final gender = hydrationPlanData.first['gender'] as String;
    final birthday = hydrationPlanData.first['birthday'] as String;
    final wakeupTime = hydrationPlanData.first['wakeupTime'] as String;
    final bedtime = hydrationPlanData.first['bedtime'] as String;
    final dailyGoal = hydrationPlanData.first['dailyGoal'] as int;
    final useRecommendedGoal =
        hydrationPlanData.first['isUsingRecommendedDailyGoal'] as String;

    state = AsyncValue.data(
      HydrationPlan(
        gender: gender.toGender,
        birthday: birthday.toDateTime,
        wakeupTime: wakeupTime.toTimeOfDay,
        bedtime: bedtime.toTimeOfDay,
        dailyGoal: dailyGoal,
        useRecommendedGoal: useRecommendedGoal.toBool,
      ),
    );
  }

  Future<void> updateGender(Gender gender) async {
    await dbHelper.updateGender(gender);

    await fetchHydrationPlan();
  }

  Future<void> updatebirthday(DateTime birthday) async {
    await dbHelper.updateBirthday(birthday);

    await fetchHydrationPlan();
  }

  Future<void> updateWakeupTime(TimeOfDay wakeupTime) async {
    await dbHelper.updateWakeupTime(wakeupTime);

    await fetchHydrationPlan();
  }

  Future<void> updateBedtime(TimeOfDay bedtime) async {
    await dbHelper.updateBedtime(bedtime);

    await fetchHydrationPlan();
  }

  Future<void> updateDailyGoal(int dailyGoal) async {
    await dbHelper.updateDailyGoal(dailyGoal);

    await fetchHydrationPlan();

    await read(userInfoProvider.notifier).fetchUserInfo();
  }

  Future<void> updateLiquidMeasurement(
    LiquidMeasurement liquidMeasurement,
  ) async {
    await dbHelper.updateLiquidMeasurement(liquidMeasurement);

    await fetchHydrationPlan();

    await read(userInfoProvider.notifier).fetchUserInfo();
  }

  Future<void> updateUseRecommendedGoal(bool useRecommendedGoal) async {
    await dbHelper.updateUseRecommendedGoal(useRecommendedGoal);

    await fetchHydrationPlan();
  }

  Future<int> calculateDailyGoal() async {
    final hydrationPlanData = await dbHelper.fetchHydrationPlan();

    final gender = hydrationPlanData.first['gender'] as String;
    final birthday = hydrationPlanData.first['birthday'] as String;
    final liquidMeasurement =
        hydrationPlanData.first['liquidMeasurement'] as String;
    final useRecommendedGoal =
        hydrationPlanData.first['isUsingRecommendedDailyGoal'] as String;
    int dailyGoal;

    final age = getAge(birthday.toDateTime);
    dailyGoal = getDailyGoal(
      gender.toGender,
      age,
      liquidMeasurement.toLiquidMeasurement,
    );

    if (useRecommendedGoal.toBool) {
      await updateDailyGoal(dailyGoal);
    }

    return dailyGoal;
  }
}

final hydrationPlanProvider =
    StateNotifierProvider<HydrationPlanNotifier, AsyncValue<HydrationPlan>>(
  (ref) => HydrationPlanNotifier(ref.read),
);
