class Cup {
  const Cup({
    this.selectedCupAmount,
    this.selectedCupMeasurement,
    this.allCup,
  });

  final int selectedCupAmount;
  final String selectedCupMeasurement;
  final List<Map<String, dynamic>> allCup;
}
