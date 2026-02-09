import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import '../../features/expense/data/datasources/expense_local_datasource.dart';
import '../../features/expense/data/repositories/expense_repository_impl.dart';
import '../../features/expense/domain/usecases/add_expense_usecase.dart';
import '../../features/expense/domain/usecases/delete_expense_usecase.dart';
import '../../features/expense/domain/usecases/get_expenses_usecase.dart';
import '../../features/expense/presentation/stores/expense_store.dart';

/// Simple dependency injection. No external DI package.
/// Presentation → UseCases → Repository → Datasource.
class Injection {
  static late ExpenseStore expenseStore;

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(AppConstants.expenseBoxName);

    final datasource = ExpenseLocalDatasource();
    final repository = ExpenseRepositoryImpl(datasource);

    final addExpenseUseCase = AddExpenseUseCase(repository);
    final getExpensesUseCase = GetExpensesUseCase(repository);
    final deleteExpenseUseCase = DeleteExpenseUseCase(repository);

    expenseStore = ExpenseStore(
      addExpenseUseCase: addExpenseUseCase,
      getExpensesUseCase: getExpensesUseCase,
      deleteExpenseUseCase: deleteExpenseUseCase,
    );

    await expenseStore.loadExpenses();
  }
}
