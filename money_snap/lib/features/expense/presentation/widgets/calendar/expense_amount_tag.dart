import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Minimal pill label for expense/income amount.
/// Softer green/red tones, no heavy shadows.
class ExpenseAmountTag extends StatelessWidget {
  const ExpenseAmountTag({
    super.key,
    required this.amount,
    this.fontSize = 10,
    this.compact = false,
    this.incomeColor,
    this.expenseColor,
  });

  final int amount;
  final double fontSize;
  final bool compact;
  final Color? incomeColor;
  final Color? expenseColor;

  bool get isPositive => amount > 0;
  int get absoluteAmount => amount.abs();

  String _formatAmount() {
    if (compact) return _formatCompact();
    return _formatFull();
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

    final inc = incomeColor ?? AppColors.income;
    final exp = expenseColor ?? AppColors.expense;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: isPositive ? inc.withOpacity(0.2) : exp.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _formatAmount(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isPositive ? inc : exp,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
