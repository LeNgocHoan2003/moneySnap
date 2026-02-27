import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported app currencies.
enum AppCurrency {
  vnd,
  usd,
}

/// App-wide currency controller. Persists selected currency to [SharedPreferences]
/// and provides it to [MoneyUtils] for formatting. Similar to [LocaleController].
class CurrencyController {
  CurrencyController._();

  static final CurrencyController instance = CurrencyController._();

  static const String _keyCurrency = 'app_currency';

  SharedPreferences? _prefs;

  /// Current currency for formatting. Widgets listen to this to rebuild on change.
  final ValueNotifier<AppCurrency> currency = ValueNotifier<AppCurrency>(AppCurrency.vnd);

  /// Loads saved currency from SharedPreferences. Call once before [runApp].
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_keyCurrency);
    if (raw != null) {
      for (final c in AppCurrency.values) {
        if (c.name == raw) {
          currency.value = c;
          break;
        }
      }
    }
  }

  /// Sets currency and persists it.
  Future<void> setCurrency(AppCurrency value) async {
    currency.value = value;
    await _prefs?.setString(_keyCurrency, value.name);
  }

  /// Current app currency.
  AppCurrency get currentCurrency => currency.value;
}
