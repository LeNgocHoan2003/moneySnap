// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: dart run build_runner build --delete-conflicting-outputs
// ignore_for_file: non_constant_identifier_names

part of 'expense_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

mixin _$ExpenseStore on _ExpenseStore, Store {
  late final _$expensesAtom = Atom(name: '_ExpenseStore.expenses');

  @override
  ObservableList<Expense> get expenses {
    _$expensesAtom.reportRead();
    return super.expenses;
  }

  @override
  set expenses(ObservableList<Expense> value) {
    _$expensesAtom.reportWrite(value, super.expenses, () {
      super.expenses = value;
    });
  }

  late final _$isLoadingAtom = Atom(name: '_ExpenseStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$_addExpenseAsyncAction = AsyncAction('_ExpenseStore.addExpense');

  @override
  Future<void> addExpense(Expense expense) {
    return _$_addExpenseAsyncAction.run(() => super.addExpense(expense));
  }

  late final _$_loadExpensesAsyncAction = AsyncAction('_ExpenseStore.loadExpenses');

  @override
  Future<void> loadExpenses() {
    return _$_loadExpensesAsyncAction.run(() => super.loadExpenses());
  }

  late final _$_deleteExpenseAsyncAction = AsyncAction('_ExpenseStore.deleteExpense');

  @override
  Future<void> deleteExpense(String id) {
    return _$_deleteExpenseAsyncAction.run(() => super.deleteExpense(id));
  }
}
