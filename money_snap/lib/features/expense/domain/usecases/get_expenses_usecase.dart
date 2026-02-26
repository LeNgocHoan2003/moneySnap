import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Single responsibility: get all expenses.
class GetExpensesUseCase {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  Future<List<Expense>> call() {
    return repository.getExpenses();
  }
}
