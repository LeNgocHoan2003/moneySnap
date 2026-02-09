import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/expense.dart';
import '../stores/expense_store.dart';
import '../widgets/expense_calendar_day_cell.dart';
import '../../../../core/utils/date_utils.dart' as app_utils;

/// List screen: same calendar grid as calendar screen (7 columns Mon–Sun, day cells).
class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({
    super.key,
    required this.store,
  });

  final ExpenseStore store;

  static const List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  /// Groups expenses by (year, month, day). Key = year*10000 + month*100 + day.
  static Map<int, List<Expense>> _groupByDay(List<Expense> expenses) {
    final map = <int, List<Expense>>{};
    for (final e in expenses) {
      final key = e.date.year * 10000 + e.date.month * 100 + e.date.day;
      map.putIfAbsent(key, () => []).add(e);
    }
    for (final list in map.values) {
      list.sort((a, b) => a.date.compareTo(b.date));
    }
    return map;
  }

  /// Builds flat list of (day, expenses) for grid. day=0 means empty cell.
  static List<({int day, List<Expense> expenses})> _buildMonthCells(
    int year,
    int month,
    Map<int, List<Expense>> byDay,
  ) {
    final first = DateTime(year, month, 1);
    final leadingBlanks = first.weekday - 1;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    const totalCells = 7 * 6;

    final list = <({int day, List<Expense> expenses})>[];
    for (var i = 0; i < totalCells; i++) {
      if (i < leadingBlanks || i >= leadingBlanks + daysInMonth) {
        list.add((day: 0, expenses: []));
      } else {
        final day = i - leadingBlanks + 1;
        final key = year * 10000 + month * 100 + day;
        list.add((day: day, expenses: byDay[key] ?? []));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => context.push(AppRoutes.calendar),
            tooltip: 'Calendar',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.add),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final now = DateTime.now();
          final year = now.year;
          final month = now.month;
          final byDay = _groupByDay(store.expenses);
          final cells = _buildMonthCells(year, month, byDay);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Month title
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  app_utils.AppDateUtils.formatMonthYear(DateTime(year, month)),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              // Weekday header (Mon–Sun)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: List.generate(
                    7,
                    (i) => Expanded(
                      child: Center(
                        child: Text(
                          _weekDays[i],
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Grid: 7 columns, 6 rows (same as calendar screen)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: store.loadExpenses,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 36,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: cells.length,
                    itemBuilder: (context, index) {
                      final cell = cells[index];
                      final isToday = year == now.year && month == now.month && cell.day == now.day;
                      return ExpenseCalendarDayCell(
                        day: cell.day,
                        expenses: cell.expenses,
                        isToday: isToday,
                        onTap: () {
                          if (cell.day == 0) return;
                          context.push(AppRoutes.dayPath(year, month, cell.day));
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.add),
        child: const Icon(Icons.add),
      ),
    );
  }
}
