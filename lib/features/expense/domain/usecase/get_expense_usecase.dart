import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetExpensesUseCase {
  final ExpenseRepository repo;

  GetExpensesUseCase(this.repo);

  Future<List<ExpenseEntity>> call() => repo.getExpenses();
}
