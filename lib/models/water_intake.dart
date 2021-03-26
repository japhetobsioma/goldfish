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

enum TileColors {
  Default,
  Red,
  Orange,
  Yellow,
  Green,
  Teal,
  Blue,
  LightBlue,
  Purple,
  Pink,
  Brown,
  Grey
}

class WaterIntake {
  const WaterIntake({
    this.waterIntake,
  });

  final List<Map<String, dynamic>> waterIntake;
}
