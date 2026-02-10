import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../i18n/strings.g.dart';

/// Row of weekday labels (MON → SUN). Uses localized labels when [labels] not provided.
class WeekdayRow extends StatelessWidget {
  const WeekdayRow({
    super.key,
    this.labels,
  });

  /// If null, uses localized short weekday names from i18n.
  final List<String>? labels;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final resolvedLabels = labels ??
        [
          t.commonWeekdayMonShort,
          t.commonWeekdayTueShort,
          t.commonWeekdayWedShort,
          t.commonWeekdayThuShort,
          t.commonWeekdayFriShort,
          t.commonWeekdaySatShort,
          t.commonWeekdaySunShort,
        ];
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: List.generate(
          resolvedLabels.length,
          (i) => Expanded(
            child: Center(
              child: Text(
                resolvedLabels[i],
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
