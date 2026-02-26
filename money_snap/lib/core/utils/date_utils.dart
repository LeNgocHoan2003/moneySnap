import '../../i18n/strings.g.dart';

/// Date formatting and parsing utilities.
class AppDateUtils {
  AppDateUtils._();

  static const List<String> _monthNamesEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  /// Formats [date] as yyyy-MM-dd.
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Month name + year, e.g. "February 2026".
  /// Uses English month names (legacy method for backward compatibility).
  static String formatMonthYear(DateTime date) {
    return '${_monthNamesEn[date.month - 1]} ${date.year}';
  }

  /// Month name + year using translations, e.g. "February 2026" or "Tháng 2 2026".
  static String formatMonthYearLocalized(DateTime date, Translations translations) {
    final monthNames = [
      translations.commonMonthJanuary,
      translations.commonMonthFebruary,
      translations.commonMonthMarch,
      translations.commonMonthApril,
      translations.commonMonthMay,
      translations.commonMonthJune,
      translations.commonMonthJuly,
      translations.commonMonthAugust,
      translations.commonMonthSeptember,
      translations.commonMonthOctober,
      translations.commonMonthNovember,
      translations.commonMonthDecember,
    ];
    return '${monthNames[date.month - 1]} ${date.year}';
  }
}
