import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/daily_total.dart';

class DailyTotalNotifier extends StateNotifier<AsyncValue<DailyTotal>> {
  DailyTotalNotifier() : super(const AsyncValue.loading()) {
    fetchDailyTotal();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> fetchDailyTotal() async {
    final sundayTotal = await dbHelper.getThisDayIntakeTotal(WeekDays.Sunday);
    final mondayTotal = await dbHelper.getThisDayIntakeTotal(WeekDays.Monday);
    final tuesdayTotal = await dbHelper.getThisDayIntakeTotal(WeekDays.Tuesday);
    final wednesdayTotal =
        await dbHelper.getThisDayIntakeTotal(WeekDays.Wednesday);
    final thursdayTotal =
        await dbHelper.getThisDayIntakeTotal(WeekDays.Thursday);
    final fridayTotal = await dbHelper.getThisDayIntakeTotal(WeekDays.Friday);
    final saturdayTotal =
        await dbHelper.getThisDayIntakeTotal(WeekDays.Saturday);

    state = AsyncValue.data(
      DailyTotal(
        sundayTotal: sundayTotal ?? 0,
        mondayTotal: mondayTotal ?? 0,
        tuesdayTotal: tuesdayTotal ?? 0,
        wednesdayTotal: wednesdayTotal ?? 0,
        thursdayTotal: thursdayTotal ?? 0,
        fridayTotal: fridayTotal ?? 0,
        saturdayTotal: saturdayTotal ?? 0,
      ),
    );
  }
}

final dailyTotalProvider =
    StateNotifierProvider<DailyTotalNotifier>((ref) => DailyTotalNotifier());
