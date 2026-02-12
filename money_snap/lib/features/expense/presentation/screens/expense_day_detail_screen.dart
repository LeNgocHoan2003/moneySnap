import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () => context.push(
        //       AppRoutes.addForDate(date.year, date.month, date.day),
        //     ),
        //     tooltip: context.t.expenseAddExpense,
        //   ),
        // ],
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
                              child: Container(
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
                                  
                            ),
                            Positioned(
                              right: 14,
                              top: 14,
                              child: Tooltip(
                                message: context.t.commonDelete,
                                child: Material(
                                  color: colorScheme.surface.withOpacity(0.92),
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusXs,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () => _showDeleteConfirm(
                                      context: context,
                                      store: store,
                                      expenseId: e.id,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                        AppSpacing.sm,
                                      ),
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        size: 20,
                                        color: AppColors.expense,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.expense.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    MoneyUtils.formatVietnamese(amount),
                                    style: theme.textTheme.titleLarge
                                        ?.copyWith(
                                          color: AppColors.textLight,
                                          fontWeight: FontWeight.bold,
                                        ),
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
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.push(
                AppRoutes.addForDate(date.year, date.month, date.day),
              ),
              child: const Icon(Icons.add),
            ),
    );
  }
}

Future<void> _showDeleteConfirm({
  required BuildContext context,
  required ExpenseStore store,
  required String expenseId,
}) async {
  final t = context.t;
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.expense.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          size: 28,
          color: AppColors.expense,
        ),
      ),
      title: Text(
        t.commonDelete,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        t.expenseRemoveExpenseConfirm,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(t.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.expense,
            foregroundColor: colorScheme.onError,
          ),
          child: Text(t.commonDelete),
        ),
      ],
    ),
  );
  if (ok == true) {
    await store.deleteExpense(expenseId);
    if (context.mounted) Navigator.of(context).pop();
  }
}
