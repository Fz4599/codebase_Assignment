import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repo;

  AddExpenseUseCase(this.repo);

  Future<void> call(ExpenseEntity expense) => repo.addExpense(expense);
}
