import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Single responsibility: add one expense.
class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(Expense expense) {
    return repository.addExpense(expense);
  }
}
