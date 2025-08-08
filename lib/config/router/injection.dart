import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_expense_tracker/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:daily_expense_tracker/features/auth/domain/usecase/logout_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import '../../core/network/network_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecase/login_usecase.dart';
import '../../features/auth/domain/usecase/register_usecase.dart';
import '../../features/expense/data/datasources/expense_remote_datasources.dart';
import '../../features/expense/data/repositories/expense_repository_impl.dart';
import '../../features/expense/domain/repositories/expense_repository.dart';
import '../../features/expense/domain/usecase/add_expense_usecase.dart';
import '../../features/expense/domain/usecase/delete_expense_usecase.dart';
import '../../features/expense/domain/usecase/get_expense_usecase.dart';
import '../../features/expense/domain/usecase/mark_invalid_expense_usecase.dart';
import '../../features/expense/domain/usecase/update_expense_usecase.dart';
import '../../features/expense/presentation/expense/cubit.dart';
// import '../../features/auth/presentation/auth/cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Register Hive
  final authBox = await Hive.openBox('authBox');
  sl.registerLazySingleton(() => authBox);

  //firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  //Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());

  //Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<AuthLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  // sl.registerFactory(
  //   () => AuthCubit(loginUseCase: sl(), registerUseCase: sl()),
  // );

  // Data Sources
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetExpensesUseCase(sl()));
  sl.registerLazySingleton(() => AddExpenseUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExpenseUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExpenseUseCase(sl()));
  sl.registerLazySingleton(() => MarkInvalidExpenseUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => ExpenseCubit(
      getExpenses: sl(),
      addExpense: sl(),
      updateExpense: sl(),
      deleteExpense: sl(),
      markInvalidExpense: sl(),
      networkService: sl(),
    ),
  );
  sl.registerLazySingleton(() => NetworkService());
}
