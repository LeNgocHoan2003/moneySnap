import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/money_utils.dart';
import '../../../domain/entities/expense.dart';
import 'expense_amount_tag.dart';
import 'expandable_image_badge.dart';

/// Single day cell in the calendar grid.
/// With expenses: shows photo thumbnail, 20-30% dark overlay, amount tag, indicator dots.
/// Selected/today: soft blue highlight glow.
class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.day,
    required this.expenses,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!hasExpenses) {
      return _SimpleDayCell(
        day: day,
        isToday: isToday,
        isSelected: isSelected,
        isDark: isDark,
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
      isDark: isDark,
      onTap: onTap,
    );
  }
}

class _EmptyCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated.withOpacity(0.5)
            : colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
    );
  }
}

class _SimpleDayCell extends StatelessWidget {
  const _SimpleDayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.isDark,
    this.onTap,
  });

  final int day;
  final bool isToday;
  final bool isSelected;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = isDark ? AppColors.darkSurface : colorScheme.surface;
    final todayColor = isDark
        ? AppColors.darkTodayGlow
        : AppColors.todayHighlight.withOpacity(0.5);
    final glowColor = isDark ? AppColors.darkPrimary : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isToday ? todayColor : surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: isToday
                ? Border.all(color: glowColor.withOpacity(0.5), width: 1)
                : null,
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: AppColors.overlayLight,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
          ),
        ),
      ),
    );
  }
}

/// Day with expenses: thumbnail, overlay, day number, +N badge, amount tag, indicator dots.
class _DayWithExpensesCell extends StatelessWidget {
  const _DayWithExpensesCell({
    required this.day,
    required this.expenses,
    required this.total,
    required this.firstImagePath,
    required this.isToday,
    required this.isSelected,
    required this.isDark,
    this.onTap,
  });

  final int day;
  final List<Expense> expenses;
  final int total;
  final String? firstImagePath;
  final bool isToday;
  final bool isSelected;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = isDark ? AppColors.darkSurface : colorScheme.surface;
    final todayColor = isDark
        ? AppColors.darkTodayGlow
        : AppColors.todayHighlight.withOpacity(0.5);
    final glowColor = isDark ? AppColors.darkPrimary : colorScheme.primary;
    final incomeColor = isDark ? AppColors.darkIncome : AppColors.income;
    final expenseColor = isDark ? AppColors.darkExpense : AppColors.expense;
    final hasImage = firstImagePath != null && firstImagePath!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isToday ? todayColor : surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: isToday
                ? Border.all(color: glowColor.withOpacity(0.6), width: 1.5)
                : null,
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: glowColor.withOpacity(0.25),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : isDark
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.overlayLight,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                if (hasImage)
                  Positioned.fill(
                    child: Image.file(
                      File(firstImagePath!),
                      fit: BoxFit.cover,
                      cacheWidth: 200,
                      cacheHeight: 200,
                      errorBuilder: (_, __, ___) => _PlaceholderBackground(
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                    ),
                  )
                else
                  _PlaceholderBackground(
                    colorScheme: colorScheme,
                    isDark: isDark,
                  ),
                // Dark overlay (20-30%) for text readability
                if (hasImage)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.black.withOpacity(0.25),
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Day number (top-left)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkSurface : Colors.white)
                          .withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$day',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                    ),
                  ),
                ),
                // +N badge (top-right)
                if (expenses.length > 1)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: ExpandableImageBadge(count: expenses.length - 1),
                  ),
                // Indicator dots + amount (bottom)
                Positioned(
                  left: 4,
                  right: 4,
                  bottom: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _IndicatorRow(
                        expenses: expenses,
                        incomeColor: incomeColor,
                        expenseColor: expenseColor,
                        textColor: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                      if (total != 0) ...[
                        const SizedBox(height: 4),
                        ExpenseAmountTag(
                          amount: total,
                          compact: true,
                          fontSize: 9,
                          incomeColor: incomeColor,
                          expenseColor: expenseColor,
                        ),
                      ],
                    ],
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

class _PlaceholderBackground extends StatelessWidget {
  const _PlaceholderBackground({
    required this.colorScheme,
    required this.isDark,
  });

  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark
          ? AppColors.darkSurfaceElevated
          : colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.receipt_long_rounded,
          size: 22,
          color: isDark
              ? AppColors.darkTextSecondary
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  const _IndicatorRow({
    required this.expenses,
    required this.incomeColor,
    required this.expenseColor,
    required this.textColor,
  });

  final List<Expense> expenses;
  final Color incomeColor;
  final Color expenseColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) return const SizedBox.shrink();

    final hasIncome = expenses.any((e) {
      final a =
          e.amount != 0 ? e.amount : MoneyUtils.parseAmount(e.description);
      return a > 0;
    });
    final hasExpense = expenses.any((e) {
      final a =
          e.amount != 0 ? e.amount : MoneyUtils.parseAmount(e.description);
      return a < 0;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasIncome)
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              color: incomeColor,
              shape: BoxShape.circle,
            ),
          ),
        if (hasExpense)
          Container(
            width: 5,
            height: 5,
            margin: EdgeInsets.only(right: hasIncome ? 4 : 0),
            decoration: BoxDecoration(
              color: expenseColor,
              shape: BoxShape.circle,
            ),
          ),
        if (expenses.length > 1)
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              '+${expenses.length - 1}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
      ],
    );
  }
}
