import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository repo;

  UpdateExpenseUseCase(this.repo);

  Future<void> call(ExpenseEntity expense) => repo.updateExpense(expense);
}
