import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/expense.dart';
import '../../../../core/utils/date_utils.dart' as app_utils;
import 'expense_list_item.dart';

/// Month section: shows the whole month (all days). Days with no data = black; days with data = expense card(s).
class ExpenseMonthSection extends StatelessWidget {
  const ExpenseMonthSection({
    super.key,
    required this.monthDate,
    required this.expenses,
    required this.onDelete,
  });

  /// First day of that month (used for header and day count).
  final DateTime monthDate;
  final List<Expense> expenses;
  final void Function(Expense expense) onDelete;

  /// Groups expenses by day of month. Key = day (1-31).
  static Map<int, List<Expense>> _groupByDay(List<Expense> expenses, int year, int month) {
    final map = <int, List<Expense>>{};
    for (final e in expenses) {
      if (e.date.year != year || e.date.month != month) continue;
      map.putIfAbsent(e.date.day, () => []).add(e);
    }
    for (final list in map.values) {
      list.sort((a, b) => b.date.compareTo(a.date));
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final year = monthDate.year;
    final month = monthDate.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final byDay = _groupByDay(expenses, year, month);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                app_utils.AppDateUtils.formatMonthYearLocalized(monthDate, context.t),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                expenses.length == 1
                    ? context.t.expenseExpenseCount(count: 1)
                    : context.t.expenseExpenseCountPlural(count: expenses.length),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        // Use ListView.builder for better performance with many days
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth,
          itemBuilder: (context, index) {
            final day = index + 1;
            return RepaintBoundary(
              child: _DayRow(
                year: year,
                month: month,
                day: day,
                dayExpenses: byDay[day] ?? [],
                isToday: _isToday(year, month, day),
                onDelete: onDelete,
                onDayTap: () => context.push(AppRoutes.dayPath(year, month, day)),
              ),
            );
          },
        ),
      ],
    );
  }

  static bool _isToday(int year, int month, int day) {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }
}

/// One row: either black placeholder (no data) or expense card(s) for that day.
class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.year,
    required this.month,
    required this.day,
    required this.dayExpenses,
    required this.isToday,
    required this.onDelete,
    required this.onDayTap,
  });

  final int year;
  final int month;
  final int day;
  final List<Expense> dayExpenses;
  final bool isToday;
  final void Function(Expense expense) onDelete;
  final VoidCallback onDayTap;

  @override
  Widget build(BuildContext context) {
    if (dayExpenses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Material(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onDayTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isToday ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
              ),
              child: Row(
                children: [
                  Text(
                    '$day',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textLightMuted,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${month.toString().padLeft(2, '0')}/$year',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textLightDimmed),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Use ListView.builder for better performance with multiple expenses per day
    if (dayExpenses.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dayExpenses.length,
      itemBuilder: (context, index) {
        final expense = dayExpenses[index];
        return RepaintBoundary(
          child: ExpenseListItem(
            expense: expense,
            onDelete: () => onDelete(expense),
          ),
        );
      },
    );
  }
}
