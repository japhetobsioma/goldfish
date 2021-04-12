import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/cup_manager.dart';
import 'cup.dart';

class CupManagerNotifier extends StateNotifier<CupManager> {
  CupManagerNotifier(this.read) : super(_initialValue);

  final Reader read;

  static const _initialValue = CupManager(
    cupAmount: 0,
    editedCupAmount: 0,
    editedCupID: 0,
  );

  static final dbHelper = DatabaseHelper.instance;

  void setCupAmount(int cupAmount) {
    state = CupManager(
      cupAmount: cupAmount,
      editedCupAmount: state.cupAmount,
      editedCupID: state.editedCupID,
    );
  }

  void setEditedCupValue({
    @required int editedCupAmount,
    @required int editedCupID,
  }) {
    state = CupManager(
      cupAmount: state.cupAmount,
      editedCupAmount: editedCupAmount,
      editedCupID: editedCupID,
    );
  }

  Future<void> addCup() async {
    await dbHelper.addCup(state.cupAmount);
    await read(cupProvider).fetchCup();
  }

  Future<void> editCup({@required int id, @required int amount}) async {
    await dbHelper.editCup(id: id, amount: amount);
    await read(cupProvider).fetchCup();
  }

  Future<void> deleteCup() async {
    await dbHelper.deleteCup(state.editedCupID);

    await read(cupProvider).fetchCup();
  }
}

final cupManagerProvider = StateNotifierProvider<CupManagerNotifier>(
  (ref) => CupManagerNotifier(ref.read),
);
