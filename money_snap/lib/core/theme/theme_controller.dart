import 'package:flutter/material.dart';

/// Simple app-wide theme controller using [ValueNotifier].
///
/// This keeps the implementation lightweight and avoids touching
/// any existing business logic. Persistence can be added later
/// without changing the public API of this controller.
class ThemeController {
  ThemeController._();

  static final ThemeController instance = ThemeController._();

  /// Current theme mode for the app.
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Toggle between light and dark theme.
  void setDarkMode(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

