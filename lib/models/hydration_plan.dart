import 'package:flutter/material.dart';

import 'user_info.dart';

class HydrationPlan {
  HydrationPlan({
    @required this.gender,
    @required this.birthday,
    @required this.wakeupTime,
    @required this.bedtime,
    @required this.dailyGoal,
    @required this.useRecommendedGoal,
  });

  final Gender gender;
  final DateTime birthday;
  final TimeOfDay wakeupTime;
  final TimeOfDay bedtime;
  final int dailyGoal;
  final bool useRecommendedGoal;
}
