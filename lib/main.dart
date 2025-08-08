import 'package:daily_expense_tracker/config/router/router.dart';
import 'package:daily_expense_tracker/core/constants/router_constants.dart';
import 'package:daily_expense_tracker/features/auth/data/models/user_model.dart';
import 'package:daily_expense_tracker/features/auth/presentation/auth/login/view.dart';
import 'package:daily_expense_tracker/features/expense/presentation/expense/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:daily_expense_tracker/config/router/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(UserModelAdapter());
  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ExpenseCubit>(
          create: (_) => di.sl<ExpenseCubit>()..fetchExpenses(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Daily Expense Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: appRouter,
    );
  }
}
