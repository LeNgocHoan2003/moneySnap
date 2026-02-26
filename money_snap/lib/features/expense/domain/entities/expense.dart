/// Pure data entity. No Flutter imports.
class Expense {
  final String id;
  final String imagePath;
  final String description;
  final DateTime date;
  /// Amount in VND (positive). Use 0 for legacy records stored as digits in description.
  final int amount;

  Expense({
    required this.id,
    required this.imagePath,
    required this.description,
    required this.date,
    this.amount = 0,
  });
}
