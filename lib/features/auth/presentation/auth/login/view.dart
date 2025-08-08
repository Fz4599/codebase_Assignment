import 'package:daily_expense_tracker/core/constants/router_constants.dart';
import 'package:daily_expense_tracker/features/auth/presentation/auth/login/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/router/injection.dart';
import '../../../domain/usecase/login_usecase.dart';
import 'cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => LoginCubit(loginUseCase: sl<LoginUseCase>()),
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
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  } else if (state is LoginSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Welcome ${state.user.name}"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.goNamed(RouterConstants.expense);
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        "Welcome Back 👋",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Login to your account",
                        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 40),

                      // Email field
                      _buildTextField(
                        controller: _emailController,
                        label: "Email",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      // Password field
                      _buildTextField(
                        controller: _passwordController,
                        label: "Password",
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            final email = _emailController.text;
                            final password = _passwordController.text;
                            context.read<LoginCubit>().login(email, password);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Register Text
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(RouterConstants.register);
                          },
                          child: const Text(
                            "Don't have an account? Register",
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
