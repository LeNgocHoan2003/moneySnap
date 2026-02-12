import 'package:flutter/material.dart';

import '../../../../../i18n/strings.g.dart';
import '../../../domain/entities/expense.dart';
import '../../stores/expense_store.dart';

/// Dialog for editing expense date and time.
class EditTimeDialog {
  /// Shows the edit time dialog and handles date/time update if confirmed.
  static Future<void> show({
    required BuildContext context,
    required ExpenseStore store,
    required Expense expense,
  }) async {
    final t = context.t;
    final theme = Theme.of(context);
    
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(expense.date);
    DateTime selectedDate = expense.date;
    
    // Create unique key for this dialog instance
    final dialogKey = ValueKey('edit_time_${expense.id}');

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          key: dialogKey,
          title: Text(
            t.expenseEditTime,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date picker button
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(t.expenseTransactionDate),
                subtitle: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: dialogContext,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setDialogState(() {
                      selectedDate = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                },
              ),
              // Time picker button
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(t.expenseTransactionTime),
                subtitle: Text(
                  '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: dialogContext,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    setDialogState(() {
                      selectedTime = picked;
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        picked.hour,
                        picked.minute,
                      );
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.commonSave),
            ),
          ],
        ),
      ),
    );

    if (result == true && context.mounted) {
      final updatedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      final updatedExpense = Expense(
        id: expense.id,
        imagePath: expense.imagePath,
        description: expense.description,
        date: updatedDate,
        amount: expense.amount,
      );
      await store.updateExpense(updatedExpense);
    }
  }
}
