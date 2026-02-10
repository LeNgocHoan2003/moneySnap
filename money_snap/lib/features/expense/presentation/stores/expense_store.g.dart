// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExpenseStore on _ExpenseStore, Store {
  late final _$expensesAtom =
      Atom(name: '_ExpenseStore.expenses', context: context);

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

  late final _$isLoadingAtom =
      Atom(name: '_ExpenseStore.isLoading', context: context);

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

  late final _$addExpenseAsyncAction =
      AsyncAction('_ExpenseStore.addExpense', context: context);

  @override
  Future<void> addExpense(Expense expense) {
    return _$addExpenseAsyncAction.run(() => super.addExpense(expense));
  }

  late final _$loadExpensesAsyncAction =
      AsyncAction('_ExpenseStore.loadExpenses', context: context);

  @override
  Future<void> loadExpenses() {
    return _$loadExpensesAsyncAction.run(() => super.loadExpenses());
  }

  late final _$deleteExpenseAsyncAction =
      AsyncAction('_ExpenseStore.deleteExpense', context: context);

  @override
  Future<void> deleteExpense(String id) {
    return _$deleteExpenseAsyncAction.run(() => super.deleteExpense(id));
  }

  @override
  String toString() {
    return '''
expenses: ${expenses},
isLoading: ${isLoading}
    ''';
  }
}
