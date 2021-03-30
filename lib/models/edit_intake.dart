import 'package:flutter/material.dart';

import 'drink_type.dart';
import 'tile_color.dart';
import 'user_info.dart';

class EditIntake {
  const EditIntake({
    @required this.waterIntakeID,
    @required this.amount,
    @required this.measurement,
    @required this.time,
    @required this.drinkTypes,
    @required this.tileColors,
    @required this.index,
  });

  final int waterIntakeID;
  final int amount;
  final LiquidMeasurement measurement;
  final TimeOfDay time;
  final DrinkTypes drinkTypes;
  final TileColors tileColors;
  final int index;
}
