import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../domain/entities/expense.dart';
import '../stores/expense_store.dart';
import '../stores/calendar_store.dart';
import '../widgets/expense_summary_card.dart';
import '../widgets/calendar/calendar_page.dart';

/// Main expenses list screen: summary card and calendar.
class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({
    super.key,
    required this.store,
  });

  final ExpenseStore store;

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late final CalendarStore _calendarStore;

  @override
  void initState() {
    super.initState();
    _calendarStore = CalendarStore();
  }

  List<Expense> _expensesForMonth(List<Expense> expenses) {
    return expenses.where((e) =>
        e.date.year == _calendarStore.viewYear &&
        e.date.month == _calendarStore.viewMonth).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: SvgPicture.asset(Assets.appName, width: 70, height: 70),
      //   backgroundColor: AppColors.textPrimary,
      //   elevation: 0,
      //   foregroundColor: AppColors.textPrimary,
      // ),
      body: _buildCalendarBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendarBody(BuildContext context) {
    return Observer(
      builder: (_) {
        // Only rebuild when expenses change
        final monthExpenses = _expensesForMonth(widget.store.expenses);
        return RefreshIndicator(
          onRefresh: widget.store.loadExpenses,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Observer(
                  builder: (_) => RepaintBoundary(
                    child: ExpenseSummaryCard(
                      monthDate: DateTime(
                        _calendarStore.viewYear,
                        _calendarStore.viewMonth,
                      ),
                      expenses: monthExpenses,
                    ),
                  ),
                ),
                CalendarPage(
                  store: widget.store,
                  calendarStore: _calendarStore,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
