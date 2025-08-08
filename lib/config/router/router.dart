import 'package:daily_expense_tracker/core/constants/router_constants.dart';
import 'package:daily_expense_tracker/features/auth/presentation/auth/login/view.dart';
import 'package:daily_expense_tracker/features/auth/presentation/auth/register/view.dart';
import 'package:daily_expense_tracker/features/expense/presentation/expense/view.dart';
import 'package:daily_expense_tracker/features/splash/presentation/splash_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/${RouterConstants.splash}',
  routes: [
    GoRoute(
      path: '/${RouterConstants.login}',
      name: RouterConstants.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/${RouterConstants.register}',
      name: RouterConstants.register,
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/${RouterConstants.expense}',
      name: RouterConstants.expense,
      builder: (context, state) => ExpensePage(),
    ),
    GoRoute(
      path: '/${RouterConstants.splash}',
      name: RouterConstants.splash,
      builder: (context, state) => SplashPage(),
    ),
  ],
);
