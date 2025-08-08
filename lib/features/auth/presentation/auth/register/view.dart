import 'package:daily_expense_tracker/core/constants/router_constants.dart';
import 'package:daily_expense_tracker/core/widgets/app_button.dart';
import 'package:daily_expense_tracker/core/widgets/app_text_field.dart';
import 'package:daily_expense_tracker/features/auth/presentation/auth/register/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/router/injection.dart';
import '../../../domain/usecase/register_usecase.dart';
import 'cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
          RegisterCubit(registerUseCase: sl<RegisterUseCase>()),
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocConsumer<RegisterCubit, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  } else if (state is RegisterSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Welcome ${state.user.name}"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.goNamed(RouterConstants.login);
                  }
                },
                builder: (context, state) {
                  if (state is RegisterLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        "Create Account ✨",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign up to get started",
                        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 40),

                      // Name
                      AppTextField(
                        controller: _nameController,
                        label: "Name",
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),

                      // Email
                      AppTextField(
                        controller: _emailController,
                        label: "Email",
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 20),

                      // Password
                      AppTextField(
                        controller: _passwordController,
                        label: "Password",
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),

                      // Register Button
                      AppButton(
                        text: "Register",
                        onPressed: () {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          final name = _nameController.text.trim();
                          context
                              .read<RegisterCubit>()
                              .register(email, password, name.isEmpty ? 'New User' : name);
                        },
                      ),

                      const SizedBox(height: 20),

                      // Already have account?
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.goNamed(RouterConstants.login);
                          },
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
