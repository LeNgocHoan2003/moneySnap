import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:money_snap/core/currency/currency_controller.dart';
import 'package:money_snap/core/utils/money_utils.dart';
import 'package:money_snap/features/expense/domain/entities/expense.dart';

/// Key used to store today's expenses JSON in home_widget storage.
const String kTodayExpensesKey = 'today_expenses';

/// Android widget provider class name (must match AndroidManifest).
const String kAndroidWidgetName = 'MyHomeWidget';

/// Updates the home widget with today's expense list and total.
/// Call after expenses are loaded, added, or deleted.
Future<void> updateHomeWidgetWithTodayExpenses(List<Expense> allExpenses) async {
  final now = DateTime.now();
  final todayKey = now.year * 10000 + now.month * 100 + now.day;
  final todayExpenses = allExpenses
      .where((e) =>
          e.date.year * 10000 + e.date.month * 100 + e.date.day == todayKey)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  final totalAmount = todayExpenses.fold<int>(
    0,
    (sum, e) => sum + (e.amount.abs()),
  );
  final currency = CurrencyController.instance.currentCurrency;
  final totalFormatted = MoneyUtils.formatVietnamese(totalAmount, currency);

  final items = todayExpenses
      .map((e) => {
            'imagePath': e.imagePath,
            'amount': e.amount,
          })
      .toList();

  final payload = {
    'items': items,
    'totalFormatted': totalFormatted,
  };
  final jsonString = jsonEncode(payload);

  await HomeWidget.saveWidgetData<String>(kTodayExpensesKey, jsonString);
  await HomeWidget.updateWidget(androidName: kAndroidWidgetName);
}
