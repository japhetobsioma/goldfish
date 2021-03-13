import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData goldfishTheme() {
  return ThemeData.light().copyWith(
    primaryColor: goldfishPrimaryBlue,
    scaffoldBackgroundColor: goldfishWhite,
    toggleableActiveColor: goldfishPrimaryBlue,
  );
}
