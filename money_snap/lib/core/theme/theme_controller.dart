import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide theme controller using [ValueNotifier].
/// Persists theme mode to [SharedPreferences].
class ThemeController {
  ThemeController._();

  static final ThemeController instance = ThemeController._();

  static const String _keyThemeMode = 'theme_mode';

  SharedPreferences? _prefs;

  /// Current theme mode for the app.
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Loads saved theme from SharedPreferences. Call once before [runApp].
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final index = _prefs?.getInt(_keyThemeMode);
    if (index != null && index >= 0 && index <= 2) {
      themeMode.value = ThemeMode.values[index];
    }
  }

  /// Toggle between light and dark theme. Persists to SharedPreferences.
  void setDarkMode(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    _prefs?.setInt(_keyThemeMode, themeMode.value.index);
  }
}

