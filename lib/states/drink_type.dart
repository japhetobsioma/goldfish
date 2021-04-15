import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/drink_type.dart';

class DrinkTypeNotifier extends StateNotifier<AsyncValue<DrinkType>> {
  DrinkTypeNotifier() : super(const AsyncValue.loading()) {
    fetchDrinkType();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> fetchDrinkType() async {
    final selectedDrinkType = await dbHelper.getSelectedDrinkType();
    final allDrinkType = await dbHelper.getAllDrinkType();
    final mostDrinkTypes = await dbHelper.getMostDrinkTypes();

    state = AsyncValue.data(
      DrinkType(
        selectedDrinkType: selectedDrinkType[0]['drinkTypes'],
        allDrinkTypes: allDrinkType,
        mostDrinkTypes: mostDrinkTypes,
      ),
    );
  }

  Future<void> setSelectedDrinkType(String drinkType) async {
    await dbHelper.setSelectedDrinkType(drinkType);

    final selectedDrinkType = await dbHelper.getSelectedDrinkType();
    final allDrinkType = await dbHelper.getAllDrinkType();
    final mostDrinkTypes = await dbHelper.getMostDrinkTypes();

    state = AsyncValue.data(
      DrinkType(
        selectedDrinkType: selectedDrinkType[0]['drinkTypes'],
        allDrinkTypes: allDrinkType,
        mostDrinkTypes: mostDrinkTypes,
      ),
    );
  }
}

final drinkTypeProvider =
    StateNotifierProvider<DrinkTypeNotifier, AsyncValue<DrinkType>>(
  (ref) => DrinkTypeNotifier(),
);
