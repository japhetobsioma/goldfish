import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/water_intake.dart';

class WaterIntakeNotifier extends StateNotifier<AsyncValue<WaterIntake>> {
  WaterIntakeNotifier() : super(const AsyncValue.loading()) {
    fetchWaterIntake();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> fetchWaterIntake() async {
    final todaysTotalWaterIntake = await dbHelper.getTodaysTotalWaterIntake();
    final todaysWaterIntake = await dbHelper.getTodaysWaterIntake();

    state = AsyncValue.data(
      WaterIntake(
        todaysTotalWaterIntake: todaysTotalWaterIntake,
        todaysWaterIntake: todaysWaterIntake,
      ),
    );
  }

  Future<void> insertWaterIntake() async {
    final selectedCup = await dbHelper.getSelectedCup();
    final selectedDrinkType = await dbHelper.getSelectedDrinkType();
    final selectedTileColor = await dbHelper.getSelectedTileColor();

    await dbHelper.insertWaterIntake(
      selectedCup[0]['amount'],
      selectedCup[0]['measurement'],
      selectedDrinkType[0]['drinkTypes'],
      selectedTileColor[0]['tileColors'],
    );

    final todaysTotalWaterIntake = await dbHelper.getTodaysTotalWaterIntake();
    final todaysWaterIntake = await dbHelper.getTodaysWaterIntake();

    state = AsyncValue.data(
      WaterIntake(
        todaysTotalWaterIntake: todaysTotalWaterIntake,
        todaysWaterIntake: todaysWaterIntake,
      ),
    );
  }
}

final waterIntakeProvider =
    StateNotifierProvider<WaterIntakeNotifier>((ref) => WaterIntakeNotifier());
