import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/drink_type.dart';

class DrinkTypeNotifier extends StateNotifier<AsyncValue<DrinkType>> {
  DrinkTypeNotifier() : super(const AsyncValue.loading()) {
    _fetchDrinkType();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> _fetchDrinkType() async {
    final selectedDrinkType = await dbHelper.getSelectedDrinkType();
    final allDrinkType = await dbHelper.getAllDrinkType();

    state = AsyncValue.data(
      DrinkType(
        selectedDrinkType: selectedDrinkType[0]['drinkTypes'],
        allDrinkType: allDrinkType,
      ),
    );
  }

  Future<void> setSelectedDrinkType(String drinkType) async {
    await dbHelper.setSelectedDrinkType(drinkType);

    final selectedDrinkType = await dbHelper.getSelectedDrinkType();
    final allDrinkType = await dbHelper.getAllDrinkType();

    state = AsyncValue.data(
      DrinkType(
        selectedDrinkType: selectedDrinkType[0]['drinkTypes'],
        allDrinkType: allDrinkType,
      ),
    );
  }
}

final drinkTypeProvider =
    StateNotifierProvider<DrinkTypeNotifier>((ref) => DrinkTypeNotifier());
