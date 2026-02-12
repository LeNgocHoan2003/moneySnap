import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_snap/features/expense/domain/repositories/expense_repository.dart';
import 'package:money_snap/features/expense/domain/usecases/delete_expense_usecase.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late DeleteExpenseUseCase useCase;
  late MockExpenseRepository repository;

  setUp(() {
    repository = MockExpenseRepository();
    useCase = DeleteExpenseUseCase(repository);
  });

  group('DeleteExpenseUseCase', () {
    const tId = 'expense-id-123';

    test('completes when repository deletes expense successfully', () async {
      // Arrange
      when(() => repository.deleteExpense(any())).thenAnswer((_) async {});

      // Act
      await useCase.call(tId);

      // Assert
      verify(() => repository.deleteExpense(tId)).called(1);
    });

    test('calls repository with correct id', () async {
      // Arrange
      when(() => repository.deleteExpense(any())).thenAnswer((_) async {});

      // Act
      await useCase.call(tId);

      // Assert
      expect(
        verify(() => repository.deleteExpense(captureAny())).captured.single,
        tId,
      );
    });

    test('throws when repository throws', () async {
      // Arrange
      when(() => repository.deleteExpense(any()))
          .thenThrow(Exception('Not found'));

      // Act & Assert
      expect(() => useCase.call(tId), throwsA(isA<Exception>()));
    });

    test('handles empty id by still calling repository', () async {
      // Arrange
      when(() => repository.deleteExpense(any())).thenAnswer((_) async {});

      // Act
      await useCase.call('');

      // Assert
      verify(() => repository.deleteExpense('')).called(1);
    });
  });
}
