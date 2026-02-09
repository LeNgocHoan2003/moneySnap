import '../../domain/entities/expense.dart';

/// Data model. Extends Entity, has toJson/fromJson for Hive/serialization.
class ExpenseModel extends Expense {
  ExpenseModel({
    required super.id,
    required super.imagePath,
    required super.description,
    required super.date,
  });

  factory ExpenseModel.fromEntity(Expense entity) {
    return ExpenseModel(
      id: entity.id,
      imagePath: entity.imagePath,
      description: entity.description,
      date: entity.date,
    );
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
