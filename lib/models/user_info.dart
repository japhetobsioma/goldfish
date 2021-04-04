import 'package:flutter/material.dart';

enum Gender {
  Male,
  Female,
  None,
}
enum LiquidMeasurement {
  Milliliter,
  FluidOunce,
}

class UserInfo {
  const UserInfo({
    @required this.userInfo,
  });

  final List<Map<String, dynamic>> userInfo;
}
