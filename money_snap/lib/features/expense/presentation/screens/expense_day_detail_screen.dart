import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/date_utils.dart' as app_utils;
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/expense.dart';
import '../stores/expense_store.dart';
import '../widgets/expense_card_item.dart';
import '../widgets/expense_summary_card.dart';

/// List of expenses for one day (opened when tapping a day in the calendar).
class ExpenseDayDetailScreen extends StatelessWidget {
  const ExpenseDayDetailScreen({
    super.key,
    required this.date,
    required this.expenses,
    required this.store,
    required this.onBack,
  });

  final DateTime date;
  final List<Expense> expenses;
  final ExpenseStore store;
  final VoidCallback onBack;

  /// Filters expenses for the given date from the store.
  List<Expense> _getExpensesForDate(DateTime date, List<Expense> allExpenses) {
    final key = date.year * 10000 + date.month * 100 + date.day;
    return allExpenses
        .where((e) => e.date.year * 10000 + e.date.month * 100 + e.date.day == key)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> _refreshExpenses() async {
    await store.loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Month part: "February" (en) or "Tháng 2" (vi); year is last token.
    final formatted = app_utils.AppDateUtils.formatMonthYearLocalized(date, context.t);
    final parts = formatted.split(' ');
    final monthPart = parts.length > 1 ? parts.sublist(0, parts.length - 1).join(' ') : formatted;
    final titleText = '${date.day} $monthPart';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        actions: [
          Observer(
            builder: (_) => IconButton(
              icon: store.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              onPressed: store.isLoading ? null : _refreshExpenses,
            ),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          // Reactively filter expenses from the store
          final dayExpenses = _getExpensesForDate(date, store.expenses);

          if (dayExpenses.isEmpty) {
            return Center(
              child: Text(
                context.t.expenseNoExpensesOnDay,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                ExpenseSummaryCard(monthDate: date, expenses: dayExpenses),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: dayExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = dayExpenses[index];
                      return RepaintBoundary(
                        child: ExpenseCardItem(
                          expense: expense,
                          store: store,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_${date.year}_${date.month}_${date.day}',
        onPressed: () => context.push(
          AppRoutes.addForDate(date.year, date.month, date.day),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
