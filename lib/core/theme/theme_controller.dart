import 'package:flutter/material.dart';

/// Global theme controller for the complete TailorX app.
///
/// Use:
/// ThemeController.instance.toggleTheme();
///
/// Every screen using Theme.of(context).brightness will rebuild
/// automatically when the mode changes.
class ThemeController extends ChangeNotifier {
  ThemeController._();

  static final ThemeController instance = ThemeController._();

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setLightMode() {
    if (_themeMode == ThemeMode.light) return;

    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setDarkMode() {
    if (_themeMode == ThemeMode.dark) return;

    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void useSystemMode() {
    if (_themeMode == ThemeMode.system) return;

    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  /// Switches between light and dark.
  ///
  /// The current real screen brightness is passed from the button,
  /// so this also works correctly when the app starts in system mode.
  void toggleTheme({
    required bool currentlyDark,
  }) {
    _themeMode = currentlyDark
        ? ThemeMode.light
        : ThemeMode.dark;

    notifyListeners();
  }
}
