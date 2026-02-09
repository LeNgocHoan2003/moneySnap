import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_model.dart';

/// Data layer implementation of ExpenseRepository.
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDatasource datasource;

  ExpenseRepositoryImpl(this.datasource);

  @override
  Future<void> addExpense(Expense expense) async {
    await datasource.addExpense(ExpenseModel.fromEntity(expense));
  }

  @override
  Future<List<Expense>> getExpenses() async {
    return datasource.getExpenses();
  }

  @override
  Future<void> deleteExpense(String id) async {
    await datasource.deleteExpense(id);
  }
}
