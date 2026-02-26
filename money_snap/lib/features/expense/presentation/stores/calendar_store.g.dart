// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CalendarStore on _CalendarStore, Store {
  late final _$viewYearAtom =
      Atom(name: '_CalendarStore.viewYear', context: context);

  @override
  int get viewYear {
    _$viewYearAtom.reportRead();
    return super.viewYear;
  }

  @override
  set viewYear(int value) {
    _$viewYearAtom.reportWrite(value, super.viewYear, () {
      super.viewYear = value;
    });
  }

  late final _$viewMonthAtom =
      Atom(name: '_CalendarStore.viewMonth', context: context);

  @override
  int get viewMonth {
    _$viewMonthAtom.reportRead();
    return super.viewMonth;
  }

  @override
  set viewMonth(int value) {
    _$viewMonthAtom.reportWrite(value, super.viewMonth, () {
      super.viewMonth = value;
    });
  }

  late final _$selectedDateAtom =
      Atom(name: '_CalendarStore.selectedDate', context: context);

  @override
  DateTime? get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime? value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$_CalendarStoreActionController =
      ActionController(name: '_CalendarStore', context: context);

  @override
  void prevMonth() {
    final _$actionInfo = _$_CalendarStoreActionController.startAction(
        name: '_CalendarStore.prevMonth');
    try {
      return super.prevMonth();
    } finally {
      _$_CalendarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextMonth() {
    final _$actionInfo = _$_CalendarStoreActionController.startAction(
        name: '_CalendarStore.nextMonth');
    try {
      return super.nextMonth();
    } finally {
      _$_CalendarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectDate(int year, int month, int day) {
    final _$actionInfo = _$_CalendarStoreActionController.startAction(
        name: '_CalendarStore.selectDate');
    try {
      return super.selectDate(year, month, day);
    } finally {
      _$_CalendarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
viewYear: ${viewYear},
viewMonth: ${viewMonth},
selectedDate: ${selectedDate}
    ''';
  }
}
