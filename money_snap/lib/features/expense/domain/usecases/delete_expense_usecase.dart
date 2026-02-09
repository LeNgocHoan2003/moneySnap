import '../repositories/expense_repository.dart';

/// Single responsibility: delete one expense by id.
class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteExpense(id);
  }
}
