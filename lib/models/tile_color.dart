enum TileColors {
  Default,
  Red,
  Orange,
  Yellow,
  Green,
  Teal,
  Blue,
  DarkBlue,
  Purple,
  Pink,
  Brown,
  Grey
}

class TileColor {
  const TileColor({
    this.selectedTileColor,
    this.allTileColor,
  });

  final String selectedTileColor;
  final List<Map<String, dynamic>> allTileColor;
}
