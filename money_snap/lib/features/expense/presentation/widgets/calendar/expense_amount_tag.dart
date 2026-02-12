import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/money_utils.dart';

/// Pill label showing expense/income amount. Green for positive (income), red for negative (expense).
class ExpenseAmountTag extends StatelessWidget {
  const ExpenseAmountTag({
    super.key,
    required this.amount,
    this.fontSize = 10,
    this.compact = false,
  });

  /// Amount can be positive (income) or negative (expense)
  final int amount;
  final double fontSize;
  /// When true, uses compact format (e.g. "+433K" or "-433K") for small UI like calendar day cell.
  final bool compact;

  bool get isPositive => amount > 0;
  int get absoluteAmount => amount.abs();

  String _formatAmount() {
    if (compact) {
      return _formatCompact();
    } else {
      return _formatFull();
    }
  }

  String _formatCompact() {
    if (absoluteAmount == 0) return '';
    if (absoluteAmount < 1000) {
      return '${isPositive ? '+' : '-'}$absoluteAmount';
    }
    final k = absoluteAmount / 1000;
    final s = k == k.truncateToDouble()
        ? k.toInt().toString()
        : k.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    return '${isPositive ? '+' : '-'}${s}K';
  }

  String _formatFull() {
    final s = absoluteAmount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '${isPositive ? '+' : '-'}$sđ';
  }

  @override
  Widget build(BuildContext context) {
    if (amount == 0) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: isPositive 
            ? AppColors.income.withOpacity(0.5)
            : AppColors.expense.withOpacity(0.5),
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
        _formatAmount(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textLight.withOpacity(0.9),
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
