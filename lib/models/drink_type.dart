import 'package:flutter/material.dart';

enum DrinkTypes {
  Water,
  HotChocolate,
  Coffee,
  Lemonade,
  IcedTea,
  Juice,
  Milkshake,
  Tea,
  Milk,
  Beer,
  Soda,
  Wine,
  Liquor,
}

class DrinkType {
  const DrinkType({
    @required this.selectedDrinkType,
    @required this.allDrinkTypes,
    @required this.mostDrinkTypes,
  })  : assert(selectedDrinkType != null),
        assert(allDrinkTypes != null),
        assert(mostDrinkTypes != null);

  final String selectedDrinkType;
  final List<Map<String, dynamic>> allDrinkTypes;
  final List<Map<String, dynamic>> mostDrinkTypes;
}
