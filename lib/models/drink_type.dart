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
    this.selectedDrinkType,
    this.allDrinkType,
  });

  final String selectedDrinkType;
  final List<Map<String, dynamic>> allDrinkType;
}
