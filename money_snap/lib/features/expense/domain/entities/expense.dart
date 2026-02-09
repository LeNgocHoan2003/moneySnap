/// Pure data entity. No Flutter imports.
class Expense {
  final String id;
  final String imagePath;
  final String description;
  final DateTime date;

  Expense({
    required this.id,
    required this.imagePath,
    required this.description,
    required this.date,
  });
}
