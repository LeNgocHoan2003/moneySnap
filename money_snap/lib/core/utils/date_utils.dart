/// Date formatting and parsing utilities.
class AppDateUtils {
  AppDateUtils._();

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  /// Formats [date] as yyyy-MM-dd.
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Month name + year, e.g. "February 2026".
  static String formatMonthYear(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.year}';
  }
}
