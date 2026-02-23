import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../../core/utils/date_utils.dart' as app_utils;

/// Calendar header: chevron buttons and month/year label.
/// Minimal styling, soft colors.
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: onPrevMonth,
            color: colorScheme.onSurfaceVariant,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Text(
            app_utils.AppDateUtils.formatMonthYearLocalized(monthDate, context.t),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: onNextMonth,
            color: colorScheme.onSurfaceVariant,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
