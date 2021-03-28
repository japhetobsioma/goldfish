import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/cup.dart';

class CupNotifier extends StateNotifier<AsyncValue<Cup>> {
  CupNotifier() : super(const AsyncValue.loading()) {
    _fetchCup();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> _fetchCup() async {
    final selectedCup = await dbHelper.getSelectedCup();
    final allCup = await dbHelper.getAllCup();

    state = AsyncValue.data(
      Cup(
        selectedCupID: selectedCup[0]['cupID'],
        amount: selectedCup[0]['amount'],
        measurement: selectedCup[0]['measurement'],
        allCup: allCup,
      ),
    );
  }

  Future<void> setSelectedCup(int cupID) async {
    await dbHelper.setSelectedCup(cupID);

    final selectedCup = await dbHelper.getSelectedCup();
    final allCup = await dbHelper.getAllCup();

    state = AsyncValue.data(
      Cup(
        selectedCupID: selectedCup[0]['cupID'],
        amount: selectedCup[0]['amount'],
        measurement: selectedCup[0]['measurement'],
        allCup: allCup,
      ),
    );
  }
}

final cupProvider = StateNotifierProvider<CupNotifier>((ref) => CupNotifier());
