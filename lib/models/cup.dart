import 'package:goldfish/models/user_info.dart';

class Cup {
  const Cup({
    this.amount,
    this.measurement,
    this.isActive,
  });

  final int amount;
  final LiquidMeasurement measurement;
  final bool isActive;
}
