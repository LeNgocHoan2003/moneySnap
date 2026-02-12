import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/money_utils.dart';
import '../../../domain/entities/expense.dart';
import 'expense_amount_tag.dart';
import 'expandable_image_badge.dart';

/// Single day cell in the calendar grid.
/// States: empty, normal, selected (purple circle), today (soft highlight), with expenses (thumbnail + amount tag).
class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.day,
    required this.expenses,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  /// Day of month (1-31), or 0 for empty cell.
  final int day;
  final List<Expense> expenses;
  final bool isToday;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (day == 0) {
      return _EmptyCell();
    }

    // Calculate net total: sum of all amounts (positive = income, negative = expense)
    final total = expenses.fold<int>(
      0,
      (s, e) {
        final amount = e.amount != 0 
            ? e.amount 
            : MoneyUtils.parseAmount(e.description.isEmpty ? '' : e.description);
        return s + amount;
      },
    );
    final hasExpenses = expenses.isNotEmpty;
    final firstImage = hasExpenses && expenses.first.imagePath.isNotEmpty
        ? expenses.first.imagePath
        : null;

    if (!hasExpenses) {
      return _SimpleDayCell(
        day: day,
        isToday: isToday,
        isSelected: isSelected,
        onTap: onTap,
      );
    }

    return _DayWithExpensesCell(
      day: day,
      expenses: expenses,
      total: total,
      firstImagePath: firstImage,
      isToday: isToday,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}

/// Empty slot (previous/next month).
class _EmptyCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        // Use a subtle surface color so empty cells are visible
        // against both light and dark backgrounds.
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
    );
  }
}

/// Day with no expenses: small day number; selected = purple circle; today = light highlight.
class _SimpleDayCell extends StatelessWidget {
  const _SimpleDayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    this.onTap,
  });

  final int day;
  final bool isToday;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isToday
                ? colorScheme.primary.withOpacity(0.12)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: _DayNumber(
            day: day,
            isToday: isToday,
            isSelected: isSelected,
          ),
        ),
      ),
    );
  }
}

/// Day with expenses: Stack of day number, thumbnail (+N badge), amount tag.
class _DayWithExpensesCell extends StatelessWidget {
  const _DayWithExpensesCell({
    required this.day,
    required this.expenses,
    required this.total,
    required this.firstImagePath,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  final int day;
  final List<Expense> expenses;
  final int total;
  final String? firstImagePath;
  final bool isToday;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasImage = firstImagePath != null && firstImagePath!.isNotEmpty;
    // Use scrim/shadow for image overlay so it adapts to light/dark theme.
    final overlay = colorScheme.shadow;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isToday
                ? colorScheme.primary.withOpacity(0.12)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.08),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image: full width/height
                if (hasImage)
                  Positioned.fill(
                    child: Image.file(
                      File(firstImagePath!),
                      fit: BoxFit.cover,
                      // Calendar cells are small (~50-80px), use 2x for retina
                      cacheWidth: 200,
                      cacheHeight: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: Icon(
                              Icons.receipt_long,
                              size: 24,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Positioned.fill(
                    child: Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.receipt_long,
                          size: 24,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                // Dark overlay so text is readable (only when image exists)
                if (hasImage)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            overlay.withOpacity(0.4),
                            overlay.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Day number (top-left)
                Positioned(
                  top: AppSpacing.xs,
                  left: AppSpacing.xs,
                  child: _DayNumber(
                    day: day,
                    isToday: isToday,
                    isSelected: isSelected,

                  ),
                ),
                // +N badge (top-right)
                if (expenses.length > 1)
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: ExpandableImageBadge(count: expenses.length - 1),
                  ),
                // Amount tag (bottom): green pill for positive (income), red pill for negative (expense)
                if (total != 0)
                  Positioned(
                    left: AppSpacing.xs,
                    right: AppSpacing.xs,
                    bottom: AppSpacing.xs,
                    child: Center(
                      child: ExpenseAmountTag(
                        amount: total,
                        compact: true,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Day number: optional purple circle (selected/today), otherwise plain text.
class _DayNumber extends StatelessWidget {
  const _DayNumber({
    required this.day,
    required this.isToday,
    required this.isSelected,
    this.onDarkBackground = false,
  });

  final int day;
  final bool isToday;
  final bool isSelected;
  final bool onDarkBackground;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = onDarkBackground
        ? colorScheme.surface
        : colorScheme.onSurface;
    return Text(
      '$day',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
    );
  }
}
