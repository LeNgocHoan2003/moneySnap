import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/utils/date_utils.dart' as app_utils;
import '../../../../core/utils/money_utils.dart';
import '../../domain/entities/expense.dart';

/// Summary card: month label, total amount, transaction count, budget progress bar.
class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({
    super.key,
    required this.monthDate,
    required this.expenses,
    this.monthlyBudget = AppConstants.defaultMonthlyBudget,
  });

  final DateTime monthDate;
  final List<Expense> expenses;
  final int monthlyBudget;

  /// Calculate earned amount (sum of positive amounts)
  int get _earnedAmount => expenses.fold<int>(
        0,
        (s, e) {
          final amount = e.amount != 0 ? e.amount : MoneyUtils.parseAmount(e.description);
          return s + (amount > 0 ? amount : 0);
        },
      );

  /// Calculate spent amount (sum of negative amounts, as absolute value)
  int get _spentAmount => expenses.fold<int>(
        0,
        (s, e) {
          final amount = e.amount != 0 ? e.amount : MoneyUtils.parseAmount(e.description);
          return s + (amount < 0 ? amount.abs() : 0);
        },
      );

  /// Calculate total (net: earned - spent)
  int get _totalAmount => _earnedAmount - _spentAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final earned = _earnedAmount;
    final spent = _spentAmount;
    final total = _totalAmount;
    final count = expenses.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.overlayLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left vertical bar (primary)
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app_utils.AppDateUtils.formatMonthYearLocalized(monthDate, context.t).toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 12),
                    // Earned row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.t.expenseEarned,
                          style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        Text(
                          '+${MoneyUtils.formatSummaryAmount(earned)}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.income,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Spent row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.t.expenseSpent,
                          style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        Text(
                          '-${MoneyUtils.formatSummaryAmount(spent)}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.expense,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Divider
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.border,
                    ),
                    const SizedBox(height: 12),
                    // Total row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          context.t.expenseTotal,
                          style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        Text(
                          '${total >= 0 ? '+' : ''}${MoneyUtils.formatSummaryAmount(total)}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: total >= 0 ? AppColors.income : AppColors.expense,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Transaction count
                    Text(
                      count == 1
                          ? context.t.expenseTransactionCount(count: 1)
                          : context.t.expenseTransactionCountPlural(count: count),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
