import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/money_utils.dart';

/// Suggestion chips above the keyboard for Vietnamese amount input.
/// Shows formatted VND values (e.g. 10.000đ); tap fills the amount field with raw value.
class AmountSuggestionBar extends StatefulWidget {
  const AmountSuggestionBar({
    super.key,
    required this.currentRawValue,
    required this.onTapAmount,
  });

  /// Current raw numeric string in the amount field (e.g. "50" or "120").
  final String currentRawValue;

  /// Called when user taps a chip; [rawAmount] is the value to set in the field.
  final ValueChanged<int> onTapAmount;

  @override
  State<AmountSuggestionBar> createState() => _AmountSuggestionBarState();
}

class _AmountSuggestionBarState extends State<AmountSuggestionBar> {
  int? _highlightedAmount;

  static const double _barHeight = 52;
  static const double _chipSpacing = 8;
  static const double _horizontalPadding = 14;

  @override
  Widget build(BuildContext context) {
    final amounts = MoneyUtils.suggestionAmountsFor(widget.currentRawValue);
    final primaryWithOpacity = AppColors.primary.withValues(alpha: 0.18);

    return Container(
      height: _barHeight,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        bottom: true,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
          itemCount: amounts.length,
          separatorBuilder: (_, __) => const SizedBox(width: _chipSpacing),
          itemBuilder: (context, index) {
            final amount = amounts[index];
            final isHighlighted = _highlightedAmount == amount;
            return _SuggestionChip(
              label: MoneyUtils.formatVietnamese(amount),
              backgroundColor: primaryWithOpacity,
              isHighlighted: isHighlighted,
              onTap: () {
                setState(() => _highlightedAmount = amount);
                widget.onTapAmount(amount);
                Future.delayed(const Duration(milliseconds: 150), () {
                  if (mounted) setState(() => _highlightedAmount = null);
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.label,
    required this.backgroundColor,
    required this.isHighlighted,
    required this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final bool isHighlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isHighlighted ? AppColors.primary.withValues(alpha: 0.35) : backgroundColor,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
