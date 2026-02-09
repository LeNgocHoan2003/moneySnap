import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../../features/expense/presentation/screens/add_expense_screen.dart';
import '../../features/expense/presentation/screens/expense_calendar_screen.dart';
import '../../features/expense/presentation/screens/expense_day_detail_screen.dart';
import '../../features/expense/presentation/screens/expense_list_screen.dart';

/// App route paths.
class AppRoutes {
  static const String list = '/';
  static const String add = '/add';
  static const String calendar = '/calendar';
  static const String day = '/day';

  static String dayPath(int year, int month, int day) => '/day/$year/$month/$day';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.list,
  routes: [
    GoRoute(
      path: AppRoutes.list,
      name: 'list',
      builder: (context, state) => ExpenseListScreen(
        store: Injection.expenseStore,
      ),
    ),
    GoRoute(
      path: AppRoutes.add,
      name: 'add',
      builder: (context, state) => AddExpenseScreen(
        store: Injection.expenseStore,
        onSaved: () => context.pop(),
      ),
    ),
    GoRoute(
      path: AppRoutes.calendar,
      name: 'calendar',
      builder: (context, state) => ExpenseCalendarScreen(
        store: Injection.expenseStore,
      ),
    ),
    GoRoute(
      path: '${AppRoutes.day}/:year/:month/:day',
      name: 'day',
      builder: (context, state) {
        final year = int.parse(state.pathParameters['year']!);
        final month = int.parse(state.pathParameters['month']!);
        final day = int.parse(state.pathParameters['day']!);
        final date = DateTime(year, month, day);
        final store = Injection.expenseStore;
        final key = year * 10000 + month * 100 + day;
        final expenses = store.expenses
            .where((e) => e.date.year * 10000 + e.date.month * 100 + e.date.day == key)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
        return ExpenseDayDetailScreen(
          date: date,
          expenses: expenses,
          store: store,
          onBack: () => context.pop(),
        );
      },
    ),
  ],
);
