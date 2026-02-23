import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../i18n/strings.g.dart';

/// Row of weekday labels. Soft, muted typography.
class WeekdayRow extends StatelessWidget {
  const WeekdayRow({super.key, this.labels});

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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
