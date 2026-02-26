import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/expense_model.dart';

/// Datasource: Hive only. No business logic.
class ExpenseLocalDatasource {
  Box<String> get _box => Hive.box<String>(AppConstants.expenseBoxName);

  Future<void> addExpense(ExpenseModel model) async {
    await _box.put(model.id, jsonEncode(model.toJson()));
  }

  Future<List<ExpenseModel>> getExpenses() async {
    final list = _box.values
        .map((e) => ExpenseModel.fromJson(Map<String, dynamic>.from(jsonDecode(e))))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }
}
