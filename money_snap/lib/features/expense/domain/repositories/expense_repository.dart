import '../entities/expense.dart';

/// Domain repository interface. Implementation lives in data layer.
abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense);
  Future<List<Expense>> getExpenses();
  Future<void> deleteExpense(String id);
}
