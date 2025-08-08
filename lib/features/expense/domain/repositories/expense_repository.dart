import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseEntity>> getExpenses();

  Future<void> addExpense(ExpenseEntity expense);

  Future<void> updateExpense(ExpenseEntity expense);

  Future<void> deleteExpense(String expenseId);

  Future<void> markInvalid(String expenseId);
}
