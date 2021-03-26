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

class TileColor {
  const TileColor({
    this.tileColors,
    this.isActive,
  });

  final TileColors tileColors;
  final bool isActive;
}
