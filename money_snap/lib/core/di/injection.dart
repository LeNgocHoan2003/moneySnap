import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import '../../features/expense/data/datasources/expense_local_datasource.dart';
import '../../features/expense/domain/repositories/expense_repository.dart';
import '../../features/expense/data/repositories/expense_repository_impl.dart';
import '../../features/expense/domain/usecases/add_expense_usecase.dart';
import '../../features/expense/domain/usecases/delete_expense_usecase.dart';
import '../../features/expense/domain/usecases/get_expenses_usecase.dart';
import '../../features/expense/presentation/stores/expense_store.dart';

/// Service locator alias for GetIt instance.
final sl = GetIt.instance;

/// Dependency injection using get_it.
/// Presentation → UseCases → Repository → Datasource.
Future<void> init() async {
  await Hive.initFlutter();
  await Hive.openBox<String>(AppConstants.expenseBoxName);

  // Datasource
  sl.registerLazySingleton<ExpenseLocalDatasource>(
    () => ExpenseLocalDatasource(),
  );

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl<ExpenseLocalDatasource>()),
  );

  // Use cases
  sl.registerLazySingleton(() => AddExpenseUseCase(sl<ExpenseRepository>()));
  sl.registerLazySingleton(() => GetExpensesUseCase(sl<ExpenseRepository>()));
  sl.registerLazySingleton(() => DeleteExpenseUseCase(sl<ExpenseRepository>()));

  // Store
  sl.registerLazySingleton<ExpenseStore>(
    () => ExpenseStore(
      addExpenseUseCase: sl<AddExpenseUseCase>(),
      getExpensesUseCase: sl<GetExpensesUseCase>(),
      deleteExpenseUseCase: sl<DeleteExpenseUseCase>(),
    ),
  );

  await sl<ExpenseStore>().loadExpenses();
}
