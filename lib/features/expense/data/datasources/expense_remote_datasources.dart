import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseModel>> getAllExpenses(String userId);

  Future<void> addExpense(String userId, ExpenseModel expense);

  Future<void> updateExpense(String userId, ExpenseModel expense);

  Future<void> deleteExpense(String userId, String expenseId);

  Future<void> markInvalid(String userId, String expenseId);
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final FirebaseFirestore firestore;

  ExpenseRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ExpenseModel>> getAllExpenses(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ExpenseModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addExpense(String userId, ExpenseModel expense) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .add(expense.toMap());
  }

  @override
  Future<void> updateExpense(String userId, ExpenseModel expense) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toMap());
  }

  @override
  Future<void> deleteExpense(String userId, String expenseId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }

  @override
  Future<void> markInvalid(String userId, String expenseId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expenseId)
        .update({'isValid': false});
  }
}
