import 'package:daily_expense_tracker/features/expense/presentation/expense/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/network_service.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecase/add_expense_usecase.dart';
import '../../domain/usecase/delete_expense_usecase.dart';
import '../../domain/usecase/get_expense_usecase.dart';
import '../../domain/usecase/mark_invalid_expense_usecase.dart';
import '../../domain/usecase/update_expense_usecase.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final GetExpensesUseCase getExpenses;
  final AddExpenseUseCase addExpense;
  final UpdateExpenseUseCase updateExpense;
  final DeleteExpenseUseCase deleteExpense;
  final MarkInvalidExpenseUseCase markInvalidExpense;
  final NetworkService networkService;

  ExpenseCubit({
    required this.getExpenses,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.markInvalidExpense,
    required this.networkService,
  }) : super(ExpenseState());

  Future<void> _checkConnectionOrThrow() async {
    if (!await networkService.hasConnection()) {
      throw Exception("No internet connection");
    }
  }

  Future<void> fetchExpenses() async {
    emit(state.copyWith(loading: true));
    try {
      await _checkConnectionOrThrow();
      final list = await getExpenses();
      emit(state.copyWith(expenses: list, loading: false));
    } catch (e, stacktrace) {
      print("Error fetching expenses: $e");
      print("Stacktrace: $stacktrace");
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> createExpense(ExpenseEntity e) async {
    try {
      await _checkConnectionOrThrow();
      await addExpense(e);
      await fetchExpenses();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateExistingExpense(ExpenseEntity e) async {
    try {
      await _checkConnectionOrThrow();
      await updateExpense(e);
      await fetchExpenses();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> removeExpense(String id) async {
    try {
      await _checkConnectionOrThrow();
      await deleteExpense(id);
      await fetchExpenses();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> invalidateExpense(String id) async {
    try {
      await _checkConnectionOrThrow();
      await markInvalidExpense(id);
      await fetchExpenses();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
