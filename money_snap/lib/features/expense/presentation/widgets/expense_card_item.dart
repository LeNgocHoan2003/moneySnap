import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/money_utils.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/expense.dart';
import '../stores/expense_store.dart';
import 'dialogs/delete_expense_dialog.dart';
import 'dialogs/edit_amount_dialog.dart';
import 'dialogs/edit_time_dialog.dart';

/// Card widget displaying a single expense item in the day detail grid.
class ExpenseCardItem extends StatelessWidget {
  const ExpenseCardItem({
    super.key,
    required this.expense,
    required this.store,
  });

  final Expense expense;
  final ExpenseStore store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Get the actual amount (can be positive or negative)
    final amount = expense.amount != 0
        ? expense.amount
        : MoneyUtils.parseAmount(expense.description);
    final isPositive = amount >= 0;
    final absoluteAmount = amount.abs();
    final hasImage = expense.imagePath.isNotEmpty;
    final timeText =
        '${expense.date.hour.toString().padLeft(2, '0')}:${expense.date.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Optional faint background image or receipt icon.
          Positioned.fill(
            child: hasImage
                ? Image.file(
                    File(expense.imagePath),
                    fit: BoxFit.cover,
                    // GridView item size is typically ~300-400px, use 2x for retina
                    cacheWidth: 800,
                    cacheHeight: 800,
                    errorBuilder: (context, error, stackTrace) {
                      return Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.receipt_long,
                            size: 40,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  )
                : Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.receipt_long,
                        size: 40,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
          ),
          // Foreground content: time/delete row (top) and amount chip (bottom).
          Positioned(
            top: 14,
            left: 14,
            child: GestureDetector(
              onTap: () => EditTimeDialog.show(
                context: context,
                store: store,
                expense: expense,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.edit,
                      size: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 14,
            child: Tooltip(
              message: context.t.commonDelete,
              child: Material(
                color: colorScheme.surface.withOpacity(0.92),
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusXs,
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => DeleteExpenseDialog.show(
                    context: context,
                    store: store,
                    expenseId: expense.id,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      AppSpacing.sm,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: AppColors.expense,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => EditAmountDialog.show(
                  context: context,
                  store: store,
                  expense: expense,
                  currentAmount: amount,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${isPositive ? '+' : '-'}${MoneyUtils.formatVietnamese(absoluteAmount)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: isPositive ? AppColors.income : AppColors.expense,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: isPositive ? AppColors.income : AppColors.expense,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
