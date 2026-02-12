import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_snap/features/expense/domain/entities/expense.dart';
import 'package:money_snap/features/expense/domain/repositories/expense_repository.dart';
import 'package:money_snap/features/expense/domain/usecases/add_expense_usecase.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late AddExpenseUseCase useCase;
  late MockExpenseRepository repository;

  setUpAll(() {
    registerFallbackValue(Expense(
      id: '',
      imagePath: '',
      description: '',
      date: DateTime(0),
    ));
  });

  setUp(() {
    repository = MockExpenseRepository();
    useCase = AddExpenseUseCase(repository);
  });

  group('AddExpenseUseCase', () {
    final tExpense = Expense(
      id: 'id-1',
      imagePath: '/path/image.jpg',
      description: 'Coffee',
      date: DateTime(2025, 2, 11),
      amount: 35000,
    );

    test('completes when repository adds expense successfully', () async {
      // Arrange
      when(() => repository.addExpense(any())).thenAnswer((_) async {});

      // Act
      await useCase.call(tExpense);

      // Assert
      verify(() => repository.addExpense(tExpense)).called(1);
    });

    test('calls repository with correct expense', () async {
      // Arrange
      when(() => repository.addExpense(any())).thenAnswer((_) async {});

      // Act
      await useCase.call(tExpense);

      // Assert
      expect(
        verify(() => repository.addExpense(captureAny())).captured.single,
        tExpense,
      );
    });

    test('throws when repository throws', () async {
      // Arrange
      when(() => repository.addExpense(any())).thenThrow(Exception('DB error'));

      // Act & Assert
      expect(() => useCase.call(tExpense), throwsA(isA<Exception>()));
    });

    test('propagates repository exception message', () async {
      // Arrange
      const message = 'Storage full';
      when(() => repository.addExpense(any()))
          .thenThrow(Exception(message));

      // Act & Assert
      expect(
        () => useCase.call(tExpense),
        throwsA(predicate<Exception>((e) => e.toString().contains(message))),
      );
    });
  });
}
