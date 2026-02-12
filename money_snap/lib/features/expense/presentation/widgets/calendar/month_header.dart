import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../../core/utils/date_utils.dart' as app_utils;

/// Calendar header: left arrow, month/year label, right arrow.
class MonthHeader extends StatelessWidget {
  const MonthHeader({
    super.key,
    required this.monthDate,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final DateTime monthDate;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevMonth,
            color: colorScheme.onSurface,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
          ),
          Text(
            app_utils.AppDateUtils.formatMonthYearLocalized(monthDate, context.t),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextMonth,
            color: colorScheme.onSurface,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
