import 'package:flutter/foundation.dart';

import '../../domain/entities/expense.dart';

/// ViewModel for calendar: view month, selected date, and derived month grid data.
/// Business logic (expenses) comes from ExpenseStore; this holds only UI state.
class CalendarViewModel extends ChangeNotifier {
  CalendarViewModel() {
    final now = DateTime.now();
    _viewYear = now.year;
    _viewMonth = now.month;
  }

  late int _viewYear;
  late int _viewMonth;
  DateTime? _selectedDate;

  int get viewYear => _viewYear;
  int get viewMonth => _viewMonth;
  DateTime? get selectedDate => _selectedDate;

  /// Whether [date] is the currently selected day (for UI highlight).
  bool isSelected(DateTime date) {
    if (_selectedDate == null) return false;
    return _selectedDate!.year == date.year &&
        _selectedDate!.month == date.month &&
        _selectedDate!.day == date.day;
  }

  void prevMonth() {
    if (_viewMonth == 1) {
      _viewMonth = 12;
      _viewYear--;
    } else {
      _viewMonth--;
    }
    notifyListeners();
  }

  void nextMonth() {
    if (_viewMonth == 12) {
      _viewMonth = 1;
      _viewYear++;
    } else {
      _viewMonth++;
    }
    notifyListeners();
  }

  void selectDate(int year, int month, int day) {
    _selectedDate = DateTime(year, month, day);
    notifyListeners();
  }

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
