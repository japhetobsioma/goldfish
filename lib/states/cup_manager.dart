import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/cup_manager.dart';
import 'cup.dart';

class CupManagerNotifier extends StateNotifier<CupManager> {
  CupManagerNotifier(this.read) : super(_initialValue);

  final Reader read;

  static const _initialValue = CupManager(0);

  static final dbHelper = DatabaseHelper.instance;

  void setCupAmount(int cupAmount) {
    state = CupManager(cupAmount);
  }

  Future<void> addCup() async {
    await dbHelper.addCup(state.cupAmount);
    await read(cupProvider).fetchCup();
  }
}

final cupManagerProvider = StateNotifierProvider<CupManagerNotifier>(
  (ref) => CupManagerNotifier(ref.read),
);
