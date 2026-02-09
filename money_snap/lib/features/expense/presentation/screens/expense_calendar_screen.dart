import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/expense.dart';
import '../stores/expense_store.dart';
import '../widgets/expense_calendar_day_cell.dart';
import '../../../../core/utils/date_utils.dart' as app_utils;

/// Monthly calendar grid: 7 columns (Mon–Sun), day cells with thumbnail and total.
class ExpenseCalendarScreen extends StatelessWidget {
  const ExpenseCalendarScreen({
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
  /// [year], [month]: current month. Monday = first column.
  static List<({int day, List<Expense> expenses})> _buildMonthCells(
    int year,
    int month,
    Map<int, List<Expense>> byDay,
  ) {
    final first = DateTime(year, month, 1);
    // Dart: 1=Mon .. 7=Sun
    final leadingBlanks = first.weekday - 1;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    const totalCells = 7 * 6; // 6 rows

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
        title: Observer(
          builder: (_) {
            final now = DateTime.now();
            return Text(app_utils.AppDateUtils.formatMonthYear(DateTime(now.year, now.month)));
          },
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Observer(
        builder: (_) {
          final now = DateTime.now();
          final year = now.year;
          final month = now.month;
          final byDay = _groupByDay(store.expenses);
          final cells = _buildMonthCells(year, month, byDay);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Weekday header (Mon–Sun)
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 10),
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
              const SizedBox(height: 4),
              // Grid: 7 columns, 5–6 rows (light spacing, rounded cards)
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 0.85,
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
            ],
          );
        },
      ),
    );
  }
}
