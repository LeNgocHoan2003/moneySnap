import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/router/app_router.dart';
import '../../stores/calendar_store.dart';
import '../../stores/expense_store.dart';
import 'calendar_grid.dart';
import 'month_header.dart';
import 'weekday_row.dart';

/// Calendar view: flat card with month header, weekday row, and day grid.
/// Minimal styling, subtle shadows.
class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    required this.store,
    this.calendarStore,
  });

  final ExpenseStore store;
  final CalendarStore? calendarStore;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarStore _calendarStore;

  @override
  void initState() {
    super.initState();
    _calendarStore = widget.calendarStore ?? CalendarStore();
  }

  @override
  void didUpdateWidget(CalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calendarStore != widget.calendarStore) {
      _calendarStore = widget.calendarStore ?? CalendarStore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor =
        isDark ? AppColors.darkSurface : colorScheme.surface;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.3)
        : AppColors.overlayLight;

    return Observer(
      builder: (_) {
        if (widget.store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final cells = CalendarStoreUtils.buildMonthCells(
          _calendarStore.viewYear,
          _calendarStore.viewMonth,
          widget.store.expenses,
        );
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: isDark ? 16 : 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Observer(
                builder: (_) => MonthHeader(
                  monthDate: DateTime(
                    _calendarStore.viewYear,
                    _calendarStore.viewMonth,
                  ),
                  onPrevMonth: _calendarStore.prevMonth,
                  onNextMonth: _calendarStore.nextMonth,
                ),
              ),
              const WeekdayRow(),
              const SizedBox(height: AppSpacing.sm),
              CalendarGrid(
                cells: cells,
                viewYear: _calendarStore.viewYear,
                viewMonth: _calendarStore.viewMonth,
                onDayTap: (year, month, day, hasExpenses) {
                  if (hasExpenses) {
                    context.push(AppRoutes.dayPath(year, month, day));
                  } else {
                    context.push(AppRoutes.addForDate(year, month, day));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
