import 'package:flutter/material.dart';

class CupManager {
  const CupManager({
    @required this.cupAmount,
    @required this.editedCupAmount,
    @required this.editedCupID,
  });

  final int cupAmount;
  final int editedCupAmount;
  final int editedCupID;
}
