import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeManager({
    ThemeMode? initialThemeMode,
  }) {
    if (initialThemeMode != null) {
      _themeMode = initialThemeMode;
    }
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
