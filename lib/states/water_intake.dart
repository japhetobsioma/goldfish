import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/water_intake.dart';

class WaterIntakeNotifier extends StateNotifier<AsyncValue<WaterIntake>> {
  WaterIntakeNotifier() : super(const AsyncValue.loading()) {
    _fetchWaterIntake();
  }

  Future<void> _fetchWaterIntake() async {
    final dbHelper = DatabaseHelper.instance;

    final waterIntake = await dbHelper.getTodaysWaterIntake();

    state = AsyncValue.data(
      WaterIntake(
        waterIntake: waterIntake,
      ),
    );
  }
}

final waterIntakeProvider =
    StateNotifierProvider<WaterIntakeNotifier>((ref) => WaterIntakeNotifier());
