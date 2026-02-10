import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/money_utils.dart';

/// Red pill label showing expense amount (e.g. -120K, -433K).
class ExpenseAmountTag extends StatelessWidget {
  const ExpenseAmountTag({
    super.key,
    required this.amount,
    this.fontSize = 10,
    this.compact = false,
  });

  final int amount;
  final double fontSize;
  /// When true, uses compact format (e.g. "-433K") for small UI like calendar day cell.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (amount <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.expense.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.overlayLight,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        compact ? MoneyUtils.formatExpenseCompact(amount) : MoneyUtils.formatVietnamese(amount),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textLight.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
