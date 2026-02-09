import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart' as app_utils;
import '../../../../core/utils/money_utils.dart';
import '../../domain/entities/expense.dart';
import '../stores/expense_store.dart';

/// List of expenses for one day (opened when tapping a day in the calendar).
class ExpenseDayDetailScreen extends StatelessWidget {
  const ExpenseDayDetailScreen({
    super.key,
    required this.date,
    required this.expenses,
    required this.store,
    required this.onBack,
  });

  final DateTime date;
  final List<Expense> expenses;
  final ExpenseStore store;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final total = expenses.fold<int>(0, (s, e) => s + MoneyUtils.parseAmount(e.description));

    return Scaffold(
      appBar: AppBar(
        title: Text('${date.day} ${app_utils.AppDateUtils.formatMonthYear(date).split(' ').first}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: expenses.isEmpty
          ? Center(
              child: Text(
                'No expenses on this day',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            MoneyUtils.formatExpense(total),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.expense,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final e = expenses[index];
                      final amount = MoneyUtils.parseAmount(e.description);
                      final hasImage = e.imagePath.isNotEmpty && File(e.imagePath).existsSync();
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: ListTile(
                          leading: hasImage
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(e.imagePath),
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(Icons.receipt_long, color: AppColors.textSecondary),
                          title: Text(MoneyUtils.formatExpense(amount)),
                          subtitle: Text(app_utils.AppDateUtils.formatDate(e.date)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete'),
                                  content: const Text('Remove this expense?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (ok == true) {
                                await store.deleteExpense(e.id);
                                if (context.mounted) Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
