import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/money_utils.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../domain/entities/expense.dart';
import '../../stores/expense_store.dart';
import 'sign_button.dart';

/// Dialog for editing expense amount.
class EditAmountDialog {
  static Future<void> show({
    required BuildContext context,
    required ExpenseStore store,
    required Expense expense,
    required int currentAmount,
  }) async {
    final result = await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _EditAmountDialogContent(
        expense: expense,
        currentAmount: currentAmount,
      ),
    );

    if (result != null && context.mounted) {
      await store.updateExpense(
        Expense(
          id: expense.id,
          imagePath: expense.imagePath,
          description: expense.description,
          date: expense.date,
          amount: result,
        ),
      );
    }
  }
}

class _EditAmountDialogContent extends StatefulWidget {
  const _EditAmountDialogContent({
    required this.expense,
    required this.currentAmount,
  });

  final Expense expense;
  final int currentAmount;

  @override
  State<_EditAmountDialogContent> createState() =>
      _EditAmountDialogContentState();
}

class _EditAmountDialogContentState extends State<_EditAmountDialogContent> {
  late final TextEditingController _controller;
  late bool _isPositive;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentAmount.abs().toString(),
    );
    _isPositive = widget.currentAmount >= 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = _isPositive ? AppColors.income : AppColors.expense;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      title: Text(
        t.expenseEditAmount,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// +/- selector with label
            Column(
              children: [
                Text(
                  _isPositive ? 'Income' : 'Expense',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SignButton(
                      label: '+',
                      isSelected: _isPositive,
                      onTap: () => setState(() => _isPositive = true),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    SignButton(
                      label: '-',
                      isSelected: !_isPositive,
                      onTap: () => setState(() => _isPositive = false),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            /// Amount input with 'đ' prefix
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.end,
              autofocus: true,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: accentColor,
                letterSpacing: 0.5,
              ),
              decoration: InputDecoration(
                prefixText: 'đ ',
                prefixStyle: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: accentColor.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
                hintText: t.expenseAmountHint,
                hintStyle: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: accentColor.withOpacity(0.05),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.lg,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: BorderSide(
                    color: accentColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: BorderSide(
                    color: accentColor,
                    width: 3,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: const BorderSide(
                    color: AppColors.expense,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: const BorderSide(
                    color: AppColors.expense,
                    width: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          child: Text(t.commonCancel),
        ),
        FilledButton(
          onPressed: () {
            final amount = MoneyUtils.parseAmount(_controller.text);
            if (amount <= 0) return;

            final signed = _isPositive ? amount : -amount;
            Navigator.pop(context, signed);
          },
          style: FilledButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: AppColors.textLight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
          child: Text(t.commonSave),
        ),
      ],
    );
  }
}
