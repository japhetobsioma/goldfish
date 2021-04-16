import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/drink_type.dart';
import '../models/edit_intake.dart';
import '../models/tile_color.dart';
import '../models/user_info.dart';
import 'water_intake.dart';

class EditIntakeNotifier extends StateNotifier<EditIntake> {
  EditIntakeNotifier(this.read) : super(_initialValue);

  Reader read;

  static final _initialValue = EditIntake(
    waterIntakeID: 0,
    amount: 0,
    measurement: LiquidMeasurement.Milliliter,
    time: TimeOfDay.now(),
    drinkTypes: DrinkTypes.Water,
    tileColors: TileColors.Default,
    index: 0,
  );

  void setEditIntake({
    @required int waterIntakeID,
    @required int amount,
    @required LiquidMeasurement measurement,
    @required TimeOfDay date,
    @required DrinkTypes drinkTypes,
    @required TileColors tileColors,
    @required int index,
  }) {
    state = EditIntake(
      waterIntakeID: waterIntakeID,
      amount: amount,
      measurement: measurement,
      time: date,
      drinkTypes: drinkTypes,
      tileColors: tileColors,
      index: index,
    );
  }

  Future<void> updateWaterIntakeCup() async {
    await read(waterIntakeProvider.notifier).updateWaterIntakeCup(
      waterIntakeID: state.waterIntakeID,
      amount: state.amount,
      measurement: state.measurement,
    );
  }

  Future<void> updateWaterIntakeDate() async {
    await read(waterIntakeProvider.notifier).updateWaterIntakeDate(
      waterIntakeID: state.waterIntakeID,
      date: state.time,
    );
  }

  Future<void> updateWaterIntakeDrinkTypes() async {
    await read(waterIntakeProvider.notifier).updateWaterIntakeDrinkTypes(
      waterIntakeID: state.waterIntakeID,
      drinkTypes: state.drinkTypes,
    );
  }

  Future<void> updateWaterIntakeTileColors() async {
    await read(waterIntakeProvider.notifier).updateWaterIntakeTileColors(
      waterIntakeID: state.waterIntakeID,
      tileColors: state.tileColors,
    );
  }

  void setSelectedCup({
    @required int amount,
    @required LiquidMeasurement measurement,
  }) async {
    state = EditIntake(
      waterIntakeID: state.waterIntakeID,
      amount: amount,
      measurement: measurement,
      time: state.time,
      drinkTypes: state.drinkTypes,
      tileColors: state.tileColors,
      index: state.index,
    );

    await updateWaterIntakeCup();
  }

  void setSelectedDrinkTypes({@required DrinkTypes drinkTypes}) async {
    state = EditIntake(
      waterIntakeID: state.waterIntakeID,
      amount: state.amount,
      measurement: state.measurement,
      time: state.time,
      drinkTypes: drinkTypes,
      tileColors: state.tileColors,
      index: state.index,
    );

    await updateWaterIntakeDrinkTypes();
  }

  void setSelectedTileColors({@required TileColors tileColors}) async {
    state = EditIntake(
      waterIntakeID: state.waterIntakeID,
      amount: state.amount,
      measurement: state.measurement,
      time: state.time,
      drinkTypes: state.drinkTypes,
      tileColors: tileColors,
      index: state.index,
    );

    await updateWaterIntakeTileColors();
  }

  void setSelectedDate({@required TimeOfDay date}) async {
    state = EditIntake(
      waterIntakeID: state.waterIntakeID,
      amount: state.amount,
      measurement: state.measurement,
      time: date,
      drinkTypes: state.drinkTypes,
      tileColors: state.tileColors,
      index: state.index,
    );

    await updateWaterIntakeDate();
  }

  Future<void> deleteWaterIntake() async {
    await read(waterIntakeProvider.notifier)
        .deleteWaterIntake(waterIntakeID: state.waterIntakeID);
  }
}

final editIntakeProvider =
    StateNotifierProvider<EditIntakeNotifier, EditIntake>(
        (ref) => EditIntakeNotifier(ref.read));

final _editWaterIntakeIDState = Provider<int>((ref) {
  return ref.watch(editIntakeProvider).waterIntakeID;
});

final editWaterIntakeIDProvider = Provider<int>((ref) {
  return ref.watch(_editWaterIntakeIDState);
});

final _editAmountState = Provider<int>((ref) {
  return ref.watch(editIntakeProvider).amount;
});

final editAmountProvider = Provider<int>((ref) {
  return ref.watch(_editAmountState);
});

final _editMeasurementState = Provider<LiquidMeasurement>((ref) {
  return ref.watch(editIntakeProvider).measurement;
});

final editMeasurementProvider = Provider<LiquidMeasurement>((ref) {
  return ref.watch(_editMeasurementState);
});

final _editDateState = Provider<TimeOfDay>((ref) {
  return ref.watch(editIntakeProvider).time;
});

final editDateProvider = Provider<TimeOfDay>((ref) {
  return ref.watch(_editDateState);
});

final _editDrinkTypesState = Provider<DrinkTypes>((ref) {
  return ref.watch(editIntakeProvider).drinkTypes;
});

final editDrinkTypesProvider = Provider<DrinkTypes>((ref) {
  return ref.watch(_editDrinkTypesState);
});

final _editTileColorsState = Provider<TileColors>((ref) {
  return ref.watch(editIntakeProvider).tileColors;
});

final editTileColorsProvider = Provider<TileColors>((ref) {
  return ref.watch(_editTileColorsState);
});

final _editIndexState = Provider<int>((ref) {
  return ref.watch(editIntakeProvider).index;
});

final editIndexProvider = Provider<int>((ref) {
  return ref.watch(_editIndexState);
});
