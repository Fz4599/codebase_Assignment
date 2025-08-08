import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasources.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remote;


  ExpenseRepositoryImpl(this.remote);

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    // await remote.addExpense(userId, expense as ExpenseModel);
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final model = ExpenseModel.fromEntity(expense);
    await remote.addExpense(userId ?? "", model);

  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await remote.deleteExpense(userId ?? "", expenseId);
  }

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return await remote.getAllExpenses(userId ?? "");
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    // await remote.updateExpense(userId, expense as ExpenseModel);
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final model = ExpenseModel.fromEntity(expense);
    await remote.updateExpense(userId ?? "", model);
  }

  @override
  Future<void> markInvalid(String expenseId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await remote.markInvalid(userId ?? "", expenseId);
  }
}
