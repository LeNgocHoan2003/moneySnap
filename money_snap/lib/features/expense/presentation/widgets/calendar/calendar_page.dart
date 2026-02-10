import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/router/app_router.dart';
import '../../viewmodels/calendar_view_model.dart';
import '../../stores/expense_store.dart';
import 'calendar_grid.dart';
import 'month_header.dart';
import 'weekday_row.dart';

/// Calendar view: white rounded card with month header, weekday row, and day grid.
/// Uses [CalendarViewModel] for view state and [ExpenseStore] for data.
class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    required this.store,
    this.viewModel,
  });

  final ExpenseStore store;
  final CalendarViewModel? viewModel;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? CalendarViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void didUpdateWidget(CalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      _viewModel.removeListener(_onViewModelChanged);
      _viewModel = widget.viewModel ?? CalendarViewModel();
      _viewModel.addListener(_onViewModelChanged);
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    if (widget.viewModel == null) {
      // We created it, so we could dispose it if it were a disposable resource.
    }
    super.dispose();
  }

  void _onViewModelChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Observer(
      builder: (_) {
        if (widget.store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final cells = CalendarViewModel.buildMonthCells(
          _viewModel.viewYear,
          _viewModel.viewMonth,
          widget.store.expenses,
        );
        return Container(
          margin: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 100),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: [
              BoxShadow(
                color: AppColors.overlayLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MonthHeader(
                monthDate: DateTime(_viewModel.viewYear, _viewModel.viewMonth),
                onPrevMonth: _viewModel.prevMonth,
                onNextMonth: _viewModel.nextMonth,
              ),
              const WeekdayRow(),
              const SizedBox(height: AppSpacing.sm),
              CalendarGrid(
                cells: cells,
                viewYear: _viewModel.viewYear,
                viewMonth: _viewModel.viewMonth,
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
