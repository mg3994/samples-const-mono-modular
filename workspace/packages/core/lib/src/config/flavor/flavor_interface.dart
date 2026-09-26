import 'package:flutter/material.dart' show Color, Locale, ThemeMode;

abstract interface class const FlavorInterface() {
  String get baseUrl;
  ThemeMode get defaultThemeMode;
  Locale get defaultLocale;
  Color get defaultThemeSeedColor;
  // const FlavorInterface();
}
