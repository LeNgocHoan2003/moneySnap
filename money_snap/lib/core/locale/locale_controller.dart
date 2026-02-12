import 'package:shared_preferences/shared_preferences.dart';

import '../../i18n/strings.g.dart';

/// App-wide locale controller. Persists selected language to [SharedPreferences]
/// and applies it on startup. Use [LocaleSettings] from slang for actual locale
/// state; this controller only handles persistence and init.
class LocaleController {
  LocaleController._();

  static final LocaleController instance = LocaleController._();

  static const String _keyLocale = 'app_locale';

  SharedPreferences? _prefs;

  /// Loads saved locale and applies it. Call once before [runApp].
  /// If user has never chosen a language, device locale is used (via [LocaleSettings.useDeviceLocale]).
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_keyLocale);
    if (raw != null) {
      final locale = AppLocaleUtils.parse(raw);
      await LocaleSettings.setLocale(locale, listenToDeviceLocale: false);
      return;
    }
    await LocaleSettings.useDeviceLocale();
  }

  /// Sets app language and persists it. [listenToDeviceLocale] is set to false
  /// so the choice is kept until user changes it again.
  Future<void> setLocale(AppLocale locale) async {
    await LocaleSettings.setLocale(locale, listenToDeviceLocale: false);
    await _prefs?.setString(_keyLocale, locale.name);
  }

  /// Current app locale (from LocaleSettings).
  AppLocale get currentLocale => LocaleSettings.currentLocale;
}
