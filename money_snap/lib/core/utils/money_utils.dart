/// Money formatting and parsing utilities.
class MoneyUtils {
  MoneyUtils._();

  /// Parses [description] as number (e.g. "50000" → 50000). Returns 0 if invalid.
  static int parseAmount(String description) {
    if (description.isEmpty) return 0;
    return int.tryParse(description.trim()) ?? 0;
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
}
