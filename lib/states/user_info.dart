import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/helpers.dart';
import '../models/user_info.dart';
import 'app_database.dart';

class UserInfoNotifier extends StateNotifier<UserInfo> {
  UserInfoNotifier(this.read) : super(_initialValue);

  final Reader read;

  static final _initialValue = UserInfo(
    gender: Gender.None,
    birthday: DateTime.now(),
    wakeupTime: TimeOfDay(
      hour: 8,
      minute: 30,
    ),
    bedtime: TimeOfDay(
      hour: 22,
      minute: 0,
    ),
    dailyGoal: 0,
    liquidMeasurement: LiquidMeasurement.Milliliter,
    isUsingRecommendedDailyGoal: true,
    joinedDate: DateTime.now(),
  );

  /// Get data from create plan then set it to the user info.
  void setUserInfo(
    Gender gender,
    String birthday,
    String wakeupTime,
    String bedtime,
    String dailyGoal,
    LiquidMeasurement liquidMeasurement,
    bool isUsingRecommenededDailyGoal,
  ) {
    state = UserInfo(
      gender: gender,
      birthday: birthday.toFormattedDate,
      wakeupTime: wakeupTime.toTime,
      bedtime: bedtime.toTime,
      dailyGoal: int.tryParse(dailyGoal),
      liquidMeasurement: liquidMeasurement,
      isUsingRecommendedDailyGoal: isUsingRecommenededDailyGoal,
      joinedDate: state.joinedDate,
    );
  }

  /// Get all the date from user info then insert it to the database.
  void createHydrationPlan() async {
    await read(appDatabaseProvider.state).createHydrationPlan(
      state.gender.name,
      state.birthday.toString(),
      state.wakeupTime.toDate,
      state.bedtime.toDate,
      state.dailyGoal,
      state.liquidMeasurement.name,
      state.isUsingRecommendedDailyGoal.toInt,
      state.joinedDate.toString(),
    );
  }

  /// Delete hydration plan from the database.
  void deleteHydrationPlan() async {
    await read(appDatabaseProvider.state).deleteHydrationPlan();
  }

  /// Print hydration plan from the database.
  void printHydrationPlan() async {
    final hydrationPlan =
        await read(appDatabaseProvider.state).readHydrationPlan().get();

    hydrationPlan.forEach((element) {
      print('Raw data from database');
      print(element.gender);
      print(element.birthday);
      print(element.wakeupTime);
      print(element.bedtime);
      print(element.dailyGoal);
      print(element.liquidMeasurement);
      print(element.isUsingRecommendedDailyGoal);
      print(element.joinedDate);

      print('Formatted data from database');
      print(element.gender);
      print(element.birthday.toStringDate);
      print(element.wakeupTime.toStringTime);
      print(element.bedtime.toStringTime);
      print(element.dailyGoal);
      print(element.liquidMeasurement);
      print(element.isUsingRecommendedDailyGoal.toBool);
      print(element.joinedDate.toStringDate);
    });
  }
}

final userInfoProvider = StateNotifierProvider<UserInfoNotifier>(
    (ref) => UserInfoNotifier(ref.read));
