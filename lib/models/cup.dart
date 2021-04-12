class Cup {
  const Cup({
    this.selectedCupAmount,
    this.selectedCupMeasurement,
    this.allCup,
    this.selectedCupID,
  });

  final int selectedCupAmount;
  final String selectedCupMeasurement;
  final List<Map<String, dynamic>> allCup;
  final int selectedCupID;
}
