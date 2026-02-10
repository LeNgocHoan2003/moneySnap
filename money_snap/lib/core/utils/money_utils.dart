/// Money formatting and parsing utilities.
class MoneyUtils {
  MoneyUtils._();

  /// Parses [description] as number (e.g. "50000" → 50000). Returns 0 if invalid.
  static int parseAmount(String description) {
    if (description.isEmpty) return 0;
    return int.tryParse(description.trim()) ?? 0;
  }

  /// Vietnamese format: dot as thousand separator, "đ" suffix (e.g. 10000 → "10.000đ").
  static String formatVietnamese(int amount) {
    if (amount == 0) return '0đ';
    final s = amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '$sđ';
  }

  /// Default suggestion amounts when input is empty (VND).
  static const List<int> defaultSuggestionAmounts = [
    10000,
    20000,
    50000,
    100000,
    200000,
    500000,
  ];

  /// Multipliers for dynamic suggestions based on current value (1k, 10k, 100k).
  static const List<int> suggestionMultipliers = [1000, 10000, 100000];

  /// Suggestion amounts: if [currentRaw] parses to > 0, returns [v*1000, v*10000, v*100000]; else defaults.
  static List<int> suggestionAmountsFor(String currentRaw) {
    final v = parseAmount(currentRaw);
    if (v <= 0) return defaultSuggestionAmounts;
    return suggestionMultipliers.map((m) => v * m).toList();
  }

  /// Formats [amount] as "-50.000đ" (red-style expense). [amount] is positive value.
  static String formatExpense(int amount) {
    if (amount == 0) return 'K';
    final s = amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '-${s}K';
  }

  /// Compact format for small UI (e.g. calendar day cell): "-433K", "-50K". [amount] is positive value.
  static String formatExpenseCompact(int amount) {
    if (amount == 0) return '';
    if (amount < 1000) return '-${amount}';
    final k = amount / 1000;
    final s = k == k.truncateToDouble()
        ? k.toInt().toString()
        : k.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    return '-${s}K';
  }

  /// Formats [amount] for summary card: "₫433.000" (VND symbol, dot thousands).
  static String formatSummaryAmount(int amount) {
    final s = amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '₫$s';
  }
}
