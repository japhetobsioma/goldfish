import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/cup.dart';

class CupNotifier extends StateNotifier<AsyncValue<Cup>> {
  CupNotifier() : super(const AsyncValue.loading()) {
    fetchCup();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> fetchCup() async {
    final selectedCup = await dbHelper.getSelectedCup();
    final allCup = await dbHelper.getAllCup();

    state = AsyncValue.data(
      Cup(
        selectedCupAmount: selectedCup[0]['amount'],
        selectedCupMeasurement: selectedCup[0]['measurement'],
        allCup: allCup,
        selectedCupID: selectedCup[0]['cupID'],
      ),
    );
  }

  Future<void> setSelectedCup(int cupID) async {
    await dbHelper.setSelectedCup(cupID);

    await fetchCup();
  }
}

final cupProvider = StateNotifierProvider<CupNotifier>((ref) => CupNotifier());
