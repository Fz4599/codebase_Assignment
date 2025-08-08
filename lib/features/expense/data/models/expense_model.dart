
import 'package:hive/hive.dart';
import '../../domain/entities/expense_entity.dart';
part 'expense_model.g.dart';

@HiveType(typeId: 1)
class ExpenseModel extends ExpenseEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String? note;

  @HiveField(5)
  final bool isValid;

  const ExpenseModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    this.isValid = true,
  }) : super(
    id: id,
    amount: amount,
    category: category,
    date: date,
    note: note,
    isValid: isValid,
  );

  factory ExpenseModel.fromMap(Map<String, dynamic> map, String id) {
    return ExpenseModel(
      id: id,
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      note: map['note'],
      isValid: map['isValid'] ?? true,
    );
  }

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      amount: entity.amount,
      category: entity.category,
      date: entity.date,
      note: entity.note,
      isValid: entity.isValid,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
      'isValid': isValid,
    };
  }
}
