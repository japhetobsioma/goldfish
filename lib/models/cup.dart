class Cup {
  const Cup({
    this.selectedCupID,
    this.amount,
    this.measurement,
    this.allCup,
  });

  final int selectedCupID;
  final int amount;
  final String measurement;
  final List<Map<String, dynamic>> allCup;
}
