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

/// Calendar view: white rounded card with month header, weekday row, and day grid.
/// Uses [CalendarStore] for view state and [ExpenseStore] for data.
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
    final colorScheme = Theme.of(context).colorScheme;
    return Observer(
      builder: (_) {
        if (widget.store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        // Only rebuild when expenses or calendar view changes
        final cells = CalendarStoreUtils.buildMonthCells(
          _calendarStore.viewYear,
          _calendarStore.viewMonth,
          widget.store.expenses,
        );
        return Container(
          margin: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 100),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: const [
              BoxShadow(
                color: AppColors.overlayLight,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Observer(
                builder: (_) => MonthHeader(
                  monthDate: DateTime(_calendarStore.viewYear, _calendarStore.viewMonth),
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
                    // When tapping a day without expenses, go to the capture (take picture) screen
                    // and prefill the date with the tapped day.
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
