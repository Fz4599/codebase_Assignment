class ExpenseEntity {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;
  final bool isValid;

  const ExpenseEntity({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    this.isValid = true,
  });
}
