import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData goldfishTheme() {
  return ThemeData.light().copyWith(
    primaryColor: goldfishPrimaryBlue,
    scaffoldBackgroundColor: goldfishWhite,
    toggleableActiveColor: goldfishPrimaryBlue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(primary: goldfishPrimaryBlue),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: goldfishPrimaryBlue),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: goldfishPrimaryBlue,
    ),
  );
}
