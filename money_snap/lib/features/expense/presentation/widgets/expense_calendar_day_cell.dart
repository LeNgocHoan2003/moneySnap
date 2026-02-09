import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/money_utils.dart';
import '../../domain/entities/expense.dart';

/// One day cell in the calendar grid: day number (top-left), thumbnail (middle), total (bottom, red).
class ExpenseCalendarDayCell extends StatelessWidget {
  const ExpenseCalendarDayCell({
    super.key,
    required this.day,
    required this.expenses,
    required this.isToday,
    required this.onTap,
  });

  /// Day of month (1-31), or 0 for empty cell.
  final int day;
  final List<Expense> expenses;
  final bool isToday;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Empty slot (not a day in current month): light background, no content
    if (day == 0) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    final total = expenses.fold<int>(
      0,
      (s, e) => s + MoneyUtils.parseAmount(e.description),
    );
    final hasExpenses = expenses.isNotEmpty;
    final firstImage = hasExpenses && expenses.first.imagePath.isNotEmpty
        ? expenses.first.imagePath
        : null;
    final fileExists = firstImage != null && File(firstImage).existsSync();

    // No expense: white card, day number only (small, top-left). No image, no amount.
    if (!hasExpenses) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: isToday
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.overlayLight,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),),
            Positioned(
              top: -16,
              left: -2,
              child: Text(
                '$day',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          
        ],
      );
    }

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: AppColors.overlayLight,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: hasExpenses
                      ? (fileExists
                            ? Image.file(File(firstImage), fit: BoxFit.cover)
                            : Container(
                                color: AppColors.surfaceVariant,
                                child: Icon(
                                  Icons.receipt_long,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                              ))
                      : Container(color: AppColors.transparent),
                ),
              ),

              // Dark overlay để chữ dễ nhìn
              if (hasExpenses)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.overlayMedium,
                          AppColors.transparent,
                          AppColors.overlayStrong,
                        ],
                      ),
                    ),
                  ),
                ),

              // Day number (top-left)
              Positioned(
                top: -16,
                left: -4,
                child: Text(
                  '$day',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),

              // "+N" badge (top-right)
              if (hasExpenses && expenses.length > 1)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '+${expenses.length - 1}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Total money (bottom-left)
              if (hasExpenses && total > 0)
                Positioned(
                  left: 4,
                  right: 4,
                  bottom: -20,
                  child: Text(
                    MoneyUtils.formatExpense(total),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.expense,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
