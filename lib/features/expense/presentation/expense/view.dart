import 'package:daily_expense_tracker/config/router/injection.dart' as di;
import 'package:daily_expense_tracker/core/network/network_listner.dart';
import 'package:daily_expense_tracker/core/widgets/app_button.dart';
import 'package:daily_expense_tracker/core/widgets/app_confirm_dialog.dart';
import 'package:daily_expense_tracker/core/widgets/app_text_field.dart';
import 'package:daily_expense_tracker/features/auth/domain/usecase/logout_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/router_constants.dart';
import '../../domain/entities/expense_entity.dart';
import 'cubit.dart';
import 'state.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NetworkListener(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: BlocBuilder<ExpenseCubit, ExpenseState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (state.error != null) {
                        return Center(
                          child: Text(
                            state.error!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      if (state.expenses.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Expenses Found',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.expenses.length,
                        itemBuilder: (context, index) {
                          final exp = state.expenses[index];
                          return _buildExpenseCard(context, exp);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () => _showAddExpenseDialog(context),
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Expenses',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(BuildContext context, ExpenseEntity exp) {
    return Card(
      color: exp.isValid
          ? Colors.white.withOpacity(0.15)
          : Colors.red.withOpacity(0.15),
      // different bg for invalid
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: exp.isValid
            ? null
            : const Icon(Icons.error_outline, color: Colors.orange),
        // invalid icon
        title: Text(
          '${exp.category}: \$${exp.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            decoration: exp.isValid
                ? null
                : TextDecoration.lineThrough, // strike-through invalid
          ),
        ),
        subtitle: Text(
          exp.note ?? '',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: PopupMenuButton<String>(
          color: Colors.white,
          onSelected: (value) {
            if (value == 'invalid') {
              context.read<ExpenseCubit>().invalidateExpense(exp.id);
            } else if (value == 'delete') {
              context.read<ExpenseCubit>().removeExpense(exp.id);
            }
          },
          itemBuilder: (context) => [
            if (exp.isValid)
              const PopupMenuItem(
                value: 'invalid',
                child: ListTile(
                  leading: Icon(Icons.error_outline, color: Colors.orange),
                  title: Text('Mark Invalid'),
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppConfirmDialog(
        icon: Icons.logout,
        iconColor: Colors.redAccent,
        title: "Logout",
        message: "Are you sure you want to logout?",
        confirmText: "Logout",
        cancelText: "Cancel",
        onConfirm: () {
          di.sl<LogoutUseCase>().call();
          context.goNamed(RouterConstants.login);
        },
      ),
    );

    if (shouldLogout == true) {
      di.sl<LogoutUseCase>().call();
      context.goNamed(RouterConstants.login);
    }
  }


  void _showAddExpenseDialog(BuildContext context) {
    final amountCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Icon
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 14),

                // Title
                const Text(
                  "Add Expense",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),

                // Fields
                AppTextField(
                  controller: amountCtrl,
                  label: "Amount",
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: categoryCtrl,
                  label: "Category",
                  icon: Icons.category_outlined,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: noteCtrl,
                  label: "Note (optional)",
                  icon: Icons.note_outlined,
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.15),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4facfe),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                          final amount = double.tryParse(amountCtrl.text);
                          final category = categoryCtrl.text.trim();

                          if (amount == null || category.isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter valid data'),
                              ),
                            );
                            return;
                          }

                          final expense = ExpenseEntity(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            amount: amount,
                            category: category,
                            date: DateTime.now(),
                            note: noteCtrl.text.trim(),
                          );

                          ctx.read<ExpenseCubit>().createExpense(expense);
                          Navigator.of(ctx).pop();
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
