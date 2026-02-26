import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/expense.dart';
import 'day_cell.dart';

/// 7-column calendar grid of day cells.
class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.cells,
    required this.viewYear,
    required this.viewMonth,
    required this.onDayTap,
  });

  /// Flat list of (day, expenses). day=0 means empty cell.
  final List<({int day, List<Expense> expenses})> cells;
  final int viewYear;
  final int viewMonth;
  /// Called when user taps a day. Only navigate when [hasExpenses] is true.
  final void Function(int year, int month, int day, bool hasExpenses) onDayTap;

  static const double _mainAxisSpacing = 8;
  static const double _crossAxisSpacing = 2;
  static const double _childAspectRatio = 0.6;

  /// Only today can be focused; other days are not selectable for focus.
  bool _isToday(int day) {
    final now = DateTime.now();
    return now.year == viewYear && now.month == viewMonth && now.day == day;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, 0, AppSpacing.sm, AppSpacing.md),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: _mainAxisSpacing,
          crossAxisSpacing: _crossAxisSpacing,
          childAspectRatio: _childAspectRatio,
        ),
        itemCount: cells.length,
        itemBuilder: (context, index) {
          final cell = cells[index];
          final isToday = _isToday(cell.day);
          return RepaintBoundary(
            child: DayCell(
              day: cell.day,
              expenses: cell.expenses,
              isToday: isToday,
              isSelected: isToday,
              onTap: cell.day == 0
                  ? null
                  : () => onDayTap(viewYear, viewMonth, cell.day, cell.expenses.isNotEmpty),
            ),
          );
        },
      ),
    );
  }
}
