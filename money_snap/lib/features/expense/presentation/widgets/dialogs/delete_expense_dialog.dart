import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../i18n/strings.g.dart';
import '../../stores/expense_store.dart';

/// Dialog for confirming expense deletion.
class DeleteExpenseDialog {
  /// Shows the delete confirmation dialog and handles deletion if confirmed.
  static Future<void> show({
    required BuildContext context,
    required ExpenseStore store,
    required String expenseId,
  }) async {
    final t = context.t;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.expense.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            size: 28,
            color: AppColors.expense,
          ),
        ),
        title: Text(
          t.commonDelete,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          t.expenseRemoveExpenseConfirm,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.expense,
              foregroundColor: colorScheme.onError,
            ),
            child: Text(t.commonDelete),
          ),
        ],
      ),
    );
    
    if (ok == true) {
      await store.deleteExpense(expenseId);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}
