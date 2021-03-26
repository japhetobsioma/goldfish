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
    this.drinkTypes,
    this.isActive,
  });

  final DrinkTypes drinkTypes;
  final bool isActive;
}
