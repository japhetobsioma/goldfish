import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/total_water.dart';

class TotalWaterIntakeNotifer
    extends StateNotifier<AsyncValue<TotalWaterIntake>> {
  TotalWaterIntakeNotifer() : super(const AsyncValue.loading()) {
    _fetchTotalWaterIntake();
  }

  Future<void> _fetchTotalWaterIntake() async {
    final dbHelper = DatabaseHelper.instance;

    final totalWaterIntake = await dbHelper.getTodaysTotalWaterIntake();

    state = AsyncValue.data(
      TotalWaterIntake(
        totalWaterIntake: totalWaterIntake,
      ),
    );
  }
}

final totalWaterIntakeProvider = StateNotifierProvider<TotalWaterIntakeNotifer>(
    (ref) => TotalWaterIntakeNotifer());
