import '../repositories/expense_repository.dart';

class MarkInvalidExpenseUseCase {
  final ExpenseRepository repo;

  MarkInvalidExpenseUseCase(this.repo);

  Future<void> call(String id) => repo.markInvalid(id);
}
