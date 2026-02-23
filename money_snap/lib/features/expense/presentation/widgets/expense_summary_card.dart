import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/utils/date_utils.dart' as app_utils;
import '../../../../core/utils/money_utils.dart';
import '../../domain/entities/expense.dart';

/// Summary card: month, Income, Expense, Total. Dark/light theme aware.
/// Highlight Total only. Softer red/green tones.
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

  int get _earnedAmount => expenses.fold<int>(
        0,
        (s, e) {
          final amount =
              e.amount != 0 ? e.amount : MoneyUtils.parseAmount(e.description);
          return s + (amount > 0 ? amount : 0);
        },
      );

  int get _spentAmount => expenses.fold<int>(
        0,
        (s, e) {
          final amount =
              e.amount != 0 ? e.amount : MoneyUtils.parseAmount(e.description);
          return s + (amount < 0 ? amount.abs() : 0);
        },
      );

  int get _totalAmount => _earnedAmount - _spentAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final earned = _earnedAmount;
    final spent = _spentAmount;
    final total = _totalAmount;
    final count = expenses.length;

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final incomeColor = isDark ? AppColors.darkIncome : AppColors.income;
    final expenseColor = isDark ? AppColors.darkExpense : AppColors.expense;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.border;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.3)
        : AppColors.overlayLight;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              app_utils.AppDateUtils.formatMonthYearLocalized(
                  monthDate, context.t),
              style: theme.textTheme.labelLarge?.copyWith(
                color: secondaryColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.t.expenseEarned,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                  ),
                ),
                Text(
                  '+${MoneyUtils.formatSummaryAmount(earned)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: incomeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.t.expenseSpent,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                  ),
                ),
                Text(
                  '-${MoneyUtils.formatSummaryAmount(spent)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: expenseColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: dividerColor),
            const SizedBox(height: 16),
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
                    fontWeight: FontWeight.w700,
                    color: total >= 0 ? incomeColor : expenseColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              count == 1
                  ? context.t.expenseTransactionCount(count: 1)
                  : context.t.expenseTransactionCountPlural(count: count),
              style: theme.textTheme.bodySmall?.copyWith(
                color: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
