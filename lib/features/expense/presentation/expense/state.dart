import '../../domain/entities/expense_entity.dart';

class ExpenseState {
  final List<ExpenseEntity> expenses;
  final bool loading;
  final String? error;

  ExpenseState({this.expenses = const [], this.loading = false, this.error});

  ExpenseState copyWith({
    List<ExpenseEntity>? expenses,
    bool? loading,
    String? error,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
