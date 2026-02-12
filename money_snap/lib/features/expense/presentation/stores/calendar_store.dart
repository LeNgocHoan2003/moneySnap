import 'package:mobx/mobx.dart';

import '../../domain/entities/expense.dart';

part 'calendar_store.g.dart';

/// Store for calendar: view month, selected date, and derived month grid data.
/// Business logic (expenses) comes from ExpenseStore; this holds only UI state.
// ignore: library_private_types_in_public_api
class CalendarStore = _CalendarStore with _$CalendarStore;

abstract class _CalendarStore with Store {
  _CalendarStore() {
    final now = DateTime.now();
    viewYear = now.year;
    viewMonth = now.month;
  }

  @observable
  int viewYear = DateTime.now().year;

  @observable
  int viewMonth = DateTime.now().month;

  @observable
  DateTime? selectedDate;

  /// Whether [date] is the currently selected day (for UI highlight).
  bool isSelected(DateTime date) {
    if (selectedDate == null) return false;
    return selectedDate!.year == date.year &&
        selectedDate!.month == date.month &&
        selectedDate!.day == date.day;
  }

  @action
  void prevMonth() {
    if (viewMonth == 1) {
      viewMonth = 12;
      viewYear--;
    } else {
      viewMonth--;
    }
  }

  @action
  void nextMonth() {
    if (viewMonth == 12) {
      viewMonth = 1;
      viewYear++;
    } else {
      viewMonth++;
    }
  }

  @action
  void selectDate(int year, int month, int day) {
    selectedDate = DateTime(year, month, day);
  }
}

/// Utility functions for calendar operations.
class CalendarStoreUtils {
  CalendarStoreUtils._();

  /// Builds the flat list of (day, expenses) for the calendar grid.
  /// day=0 means empty cell (previous/next month).
  static List<({int day, List<Expense> expenses})> buildMonthCells(
    int year,
    int month,
    List<Expense> expenses,
  ) {
    final byDay = _groupByDay(expenses);
    final first = DateTime(year, month, 1);
    final leadingBlanks = first.weekday - 1;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    const totalCells = 7 * 6;

    final list = <({int day, List<Expense> expenses})>[];
    for (var i = 0; i < totalCells; i++) {
      if (i < leadingBlanks || i >= leadingBlanks + daysInMonth) {
        list.add((day: 0, expenses: []));
      } else {
        final day = i - leadingBlanks + 1;
        final key = year * 10000 + month * 100 + day;
        list.add((day: day, expenses: byDay[key] ?? []));
      }
    }
    return list;
  }

  static Map<int, List<Expense>> _groupByDay(List<Expense> expenses) {
    final map = <int, List<Expense>>{};
    for (final e in expenses) {
      final key = e.date.year * 10000 + e.date.month * 100 + e.date.day;
      map.putIfAbsent(key, () => []).add(e);
    }
    for (final list in map.values) {
      list.sort((a, b) => a.date.compareTo(b.date));
    }
    return map;
  }
}
