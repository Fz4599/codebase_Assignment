import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repo;

  DeleteExpenseUseCase(this.repo);

  Future<void> call(String id) => repo.deleteExpense(id);
}
