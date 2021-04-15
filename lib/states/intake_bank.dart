import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/intake_bank.dart';

class IntakeBankNotifier extends StateNotifier<AsyncValue<IntakeBank>> {
  IntakeBankNotifier() : super(const AsyncValue.loading()) {
    fetchIntakeBank();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> fetchIntakeBank() async {
    final intakeBankAmount = await dbHelper.fetchIntakeBank();

    state = AsyncValue.data(
      IntakeBank(
        intakeBankAmount: intakeBankAmount[0]['intakeBank'],
      ),
    );
  }

  Future<void> updateIntakeBank({
    @required double value,
    @required String arithmeticOperator,
  }) async {
    await dbHelper.updateIntakeBank(
      value: value,
      arithmeticOperator: arithmeticOperator,
    );
  }
}

final intakeBankProvider =
    StateNotifierProvider<IntakeBankNotifier, AsyncValue<IntakeBank>>(
  (ref) => IntakeBankNotifier(),
);
