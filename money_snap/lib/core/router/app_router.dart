import 'package:go_router/go_router.dart';

import '../../features/expense/presentation/screens/capture_expense_screen.dart';
import '../../features/expense/presentation/screens/expense_calendar_screen.dart';
import '../../features/expense/presentation/screens/expense_day_detail_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

/// App route paths.
class AppRoutes {
  static const String list = '/';
  static const String add = '/add';
  static const String calendar = '/calendar';
  static const String day = '/day';
  static const String settings = '/settings';

  static String dayPath(int year, int month, int day) => '/day/$year/$month/$day';
  static String addForDate(int year, int month, int day) =>
      '$add?date=${DateTime(year, month, day).toIso8601String()}';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.list,
  routes: [
    GoRoute(
      path: AppRoutes.list,
      name: 'list',
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.add,
      name: 'add',
      builder: (context, state) {
        final dateParam = state.uri.queryParameters['date'];
        final initialDate =
            dateParam != null ? DateTime.tryParse(dateParam) : null;
        return CaptureExpenseScreen(
          initialDate: initialDate,
          onSaved: () => context.pop(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.calendar,
      name: 'calendar',
      builder: (_, __) => ExpenseCalendarScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (_, __) => const SettingsScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.day}/:year/:month/:day',
      name: 'day',
      builder: (context, state) {
        final year = int.parse(state.pathParameters['year']!);
        final month = int.parse(state.pathParameters['month']!);
        final day = int.parse(state.pathParameters['day']!);
        final date = DateTime(year, month, day);
        return ExpenseDayDetailScreen(
          date: date,
          onBack: () => context.pop(),
        );
      },
    ),
  ],
);
