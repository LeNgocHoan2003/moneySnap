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

  int get _totalAmount => expenses.fold<int>(
        0,
        (s, e) => s + (e.amount > 0 ? e.amount : MoneyUtils.parseAmount(e.description)),
      );

  double get _budgetPercent =>
      monthlyBudget <= 0 ? 0.0 : (_totalAmount / monthlyBudget).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final total = _totalAmount;
    final percent = _budgetPercent;
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
                      app_utils.AppDateUtils.formatMonthYear(monthDate).toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          MoneyUtils.formatSummaryAmount(total),
                          style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      count == 1
                          ? context.t.expenseTransactionCount(count: 1)
                          : context.t.expenseTransactionCountPlural(count: count),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: ClipRRect(
                    //         borderRadius: BorderRadius.circular(4),
                    //         child: LinearProgressIndicator(
                    //           value: percent,
                    //           backgroundColor: AppColors.border,
                    //           valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    //           minHeight: 6,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 8),
                    //     Text(
                    //       context.t.expensePercentOfBudget(percent: (percent * 100).round()),
                    //       style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    //             color: AppColors.textSecondary,
                    //           ),
                    //     ),
                    //   ],
                    // ),
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
