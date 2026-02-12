import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_snap/features/expense/domain/entities/expense.dart';
import 'package:money_snap/features/expense/domain/repositories/expense_repository.dart';
import 'package:money_snap/features/expense/domain/usecases/get_expenses_usecase.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late GetExpensesUseCase useCase;
  late MockExpenseRepository repository;

  setUp(() {
    repository = MockExpenseRepository();
    useCase = GetExpensesUseCase(repository);
  });

  group('GetExpensesUseCase', () {
    final tExpenses = [
      Expense(
        id: 'id-1',
        imagePath: '/path/1.jpg',
        description: 'Coffee',
        date: DateTime(2025, 2, 11),
        amount: 35000,
      ),
      Expense(
        id: 'id-2',
        imagePath: '/path/2.jpg',
        description: 'Lunch',
        date: DateTime(2025, 2, 11),
        amount: 80000,
      ),
    ];

    test('returns list when repository returns data successfully', () async {
      // Arrange
      when(() => repository.getExpenses()).thenAnswer((_) async => tExpenses);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, tExpenses);
      verify(() => repository.getExpenses()).called(1);
    });

    test('returns empty list when repository returns no data', () async {
      // Arrange
      when(() => repository.getExpenses()).thenAnswer((_) async => []);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
      verify(() => repository.getExpenses()).called(1);
    });

    test('throws when repository throws', () async {
      // Arrange
      when(() => repository.getExpenses()).thenThrow(Exception('DB error'));

      // Act & Assert
      expect(() => useCase.call(), throwsA(isA<Exception>()));
    });

    test('returns same list reference as repository', () async {
      // Arrange
      when(() => repository.getExpenses()).thenAnswer((_) async => tExpenses);

      // Act
      final result = await useCase.call();

      // Assert
      expect(identical(result, tExpenses), isTrue);
    });
  });
}
