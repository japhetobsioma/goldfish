import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/helpers.dart';
import '../database/database_helper.dart';
import '../models/user_info.dart';

class UserInfoNotifier extends StateNotifier<AsyncValue<UserInfo>> {
  UserInfoNotifier() : super(const AsyncValue.loading()) {
    _readUserInfo();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> _readUserInfo() async {
    final hydrationPlan = await dbHelper.readHydrationPlan();

    final String genderTypeString = hydrationPlan[0]['gender'];
    final gender = genderTypeString.toGender;

    final String birthdayTypeString = hydrationPlan[0]['birthday'];
    final birthday = birthdayTypeString.toDateTime;

    final String wakeupTimeTypeString = hydrationPlan[0]['wakeupTime'];
    final wakeupTime = wakeupTimeTypeString.toTimeOfDay;

    final String bedtimeTypeString = hydrationPlan[0]['bedtime'];
    final bedtime = bedtimeTypeString.toTimeOfDay;

    final int dailyGoal = hydrationPlan[0]['dailyGoal'];

    final String liquidMeasurementTypeString =
        hydrationPlan[0]['liquidMeasurement'];
    final liquidMeasurement = liquidMeasurementTypeString.toLiquidMeasurement;

    final String isUsingRecommendedDailyGoalTypeString =
        hydrationPlan[0]['isUsingRecommendedDailyGoal'];
    final isUsingRecommendedDailyGoal =
        isUsingRecommendedDailyGoalTypeString.toBool;

    final String joinedDateTypeString = hydrationPlan[0]['joinedDate'];
    final joinedDate = joinedDateTypeString.toDateTime;

    state = AsyncValue.data(
      UserInfo(
        gender: gender,
        birthday: birthday,
        wakeupTime: wakeupTime,
        bedtime: bedtime,
        dailyGoal: dailyGoal,
        liquidMeasurement: liquidMeasurement,
        isUsingRecommendedDailyGoal: isUsingRecommendedDailyGoal,
        joinedDate: joinedDate,
      ),
    );
  }

  /// Get all the data from create plan form then insert it to the database.
  Future<void> createHydrationPlan({
    @required Gender gender,
    @required String birthday,
    @required String wakeupTime,
    @required String bedtime,
    @required String dailyGoal,
    @required LiquidMeasurement liquidMeasurement,
    @required bool isUsingRecommendedDailyGoal,
  }) async {
    assert(gender != null);
    assert(birthday != null);
    assert(wakeupTime != null);
    assert(bedtime != null);
    assert(dailyGoal != null);
    assert(liquidMeasurement != null);
    assert(isUsingRecommendedDailyGoal != null);

    await dbHelper.createHydrationPlan(
      gender: gender,
      birthday: birthday.toDateTimeFormatted,
      wakeupTime: wakeupTime.toTimeOfDayFormatted,
      bedtime: bedtime.toTimeOfDayFormatted,
      dailyGoal: int.tryParse(dailyGoal),
      liquidMeasurement: liquidMeasurement,
      isUsingRecommendedDailyGoal: isUsingRecommendedDailyGoal,
      joinedDate: DateTime.now(),
    );
  }

  /// Delete hydration plan from the database.
  Future<void> deleteHydrationPlan() async {
    await dbHelper.deleteHydrationPlan();
  }
}

final userInfoProvider =
    StateNotifierProvider<UserInfoNotifier>((ref) => UserInfoNotifier());
