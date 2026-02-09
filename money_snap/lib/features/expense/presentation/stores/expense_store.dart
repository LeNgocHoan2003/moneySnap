import 'package:mobx/mobx.dart';

import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense_usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';

part 'expense_store.g.dart';

/// MVVM Store: calls UseCases only. Does not call Repository or Hive directly.
// ignore: library_private_types_in_public_api
class ExpenseStore = _ExpenseStore with _$ExpenseStore;

abstract class _ExpenseStore with Store {
  _ExpenseStore({
    required AddExpenseUseCase addExpenseUseCase,
    required GetExpensesUseCase getExpensesUseCase,
    required DeleteExpenseUseCase deleteExpenseUseCase,
  })  : _addExpenseUseCase = addExpenseUseCase,
        _getExpensesUseCase = getExpensesUseCase,
        _deleteExpenseUseCase = deleteExpenseUseCase;

  final AddExpenseUseCase _addExpenseUseCase;
  final GetExpensesUseCase _getExpensesUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;

  @observable
  ObservableList<Expense> expenses = ObservableList<Expense>();

  @observable
  bool isLoading = false;

  @action
  Future<void> addExpense(Expense expense) async {
    await _addExpenseUseCase(expense);
    await loadExpenses();
  }

  @action
  Future<void> loadExpenses() async {
    isLoading = true;
    try {
      final list = await _getExpensesUseCase();
      expenses.clear();
      expenses.addAll(list);
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> deleteExpense(String id) async {
    await _deleteExpenseUseCase(id);
    expenses.removeWhere((e) => e.id == id);
  }
}
