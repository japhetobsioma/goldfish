import 'package:flutter/material.dart';

ThemeData goldfishTheme() {
  final _base = ThemeData.light();

  return _base.copyWith(
    colorScheme: _goldfishColorScheme,
    accentColor: _goldfishLightBlue200,
    primaryColor: _goldfishBlue500,
    scaffoldBackgroundColor: _goldfishBackgroundWhite,
    elevatedButtonTheme: _elevatedButtonThemeData,
    errorColor: _goldfishErrorRed,
  );
}

ElevatedButtonThemeData _elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    primary: _goldfishBlue500,
  ),
);

const ColorScheme _goldfishColorScheme = ColorScheme(
  primary: _goldfishBlue500,
  primaryVariant: _goldfishBlue700,
  secondary: _goldfishLightBlue200,
  secondaryVariant: _goldfishLightBlue700,
  surface: _goldfishBackgroundWhite,
  background: _goldfishBackgroundWhite,
  error: _goldfishErrorRed,
  onPrimary: _goldfishBackgroundWhite,
  onSecondary: _goldfishBackgroundBlack,
  onSurface: _goldfishBackgroundBlack,
  onBackground: _goldfishBackgroundBlack,
  onError: _goldfishBackgroundWhite,
  brightness: Brightness.light,
);

// Colors are generated from '[Light Theme] goldfish.xd'. I use
// https://convertingcolors.com/ to conver HEX color format (Example: #00A7F4)
// to android.graphics.Color code (Example: 0xFF00A7F4).
const Color _goldfishBlue500 = Color(0xFF00A7F4);
const Color _goldfishBlue700 = Color(0xFF0385D1);

const Color _goldfishLightBlue200 = Color(0xFF82D2FA);
const Color _goldfishLightBlue700 = Color(0xFF1685CF);

const Color _goldfishBackgroundWhite = Color(0xFFFFFFFF);
const Color _goldfishBackgroundBlack = Color(0xFF000000);

const Color _goldfishErrorRed = Color(0xFFB00020);
