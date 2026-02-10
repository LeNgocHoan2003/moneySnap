import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart' as app_utils;
import '../../../../i18n/strings.g.dart';
import '../../../../core/utils/money_utils.dart';
import '../../domain/entities/expense.dart';
import '../stores/expense_store.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final total = expenses.fold<int>(
      0,
      (s, e) =>
          s + (e.amount > 0 ? e.amount : MoneyUtils.parseAmount(e.description)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${date.day} ${app_utils.AppDateUtils.formatMonthYear(date).split(' ').first}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: expenses.isEmpty
          ? Center(
              child: Text(
                context.t.expenseNoExpensesOnDay,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : Column(
              children: [
                ExpenseSummaryCard(monthDate: date, expenses: expenses),
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
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final e = expenses[index];
                      final amount = e.amount > 0
                          ? e.amount
                          : MoneyUtils.parseAmount(e.description);
                      final hasImage =
                          e.imagePath.isNotEmpty &&
                          File(e.imagePath).existsSync();
                      final timeText =
                          '${e.date.hour.toString().padLeft(2, '0')}:${e.date.minute.toString().padLeft(2, '0')}';

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            // Optional faint background image or receipt icon.
                            Positioned.fill(
                              child: hasImage
                                  ? Image.file(
                                      File(e.imagePath),
                                      fit: BoxFit.cover,
                                    )
                                  : Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.receipt_long,
                                          size: 40,
                                      color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                            ),
                            // Foreground content: time/delete row (top) and amount chip (bottom).
                            Positioned(
                              top: 14,
                              left: 14,
                              // right: 14,
                              child: (timeText != '00:00')
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surface.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Text(
                                        timeText,
                                        style: theme.textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Positioned(
                              right: 14,
                              top: 14,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.background.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  iconSize: 20,
                                  splashRadius: 20,
                                  icon: const Icon(Icons.delete_outline),
                                  color: colorScheme.onSurfaceVariant,
                                  onPressed: () async {
                                    final t = context.t;
                                    final ok = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(t.commonDelete),
                                        content: Text(
                                          t.expenseRemoveExpenseConfirm,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, false),
                                            child: Text(t.commonCancel),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, true),
                                            child: Text(t.commonDelete),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (ok == true) {
                                      await store.deleteExpense(e.id);
                                      if (context.mounted)
                                        Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              
                              right: 14,
                              bottom: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.expense.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  MoneyUtils.formatVietnamese(amount),
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(
                                        color: AppColors.expense,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
