import 'package:daily_expense_tracker/core/error/exceptions.dart';
import 'package:daily_expense_tracker/core/value_objects/email.dart';
import 'package:daily_expense_tracker/core/value_objects/password.dart';
import 'package:daily_expense_tracker/features/auth/presentation/auth/login/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/login_usecase.dart';
// import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login(String emailStr, String passwordStr) async {
    emit(LoginLoading());
    try {
      final email = Email(emailStr);
      final password = Password(passwordStr);
      final user = await loginUseCase(email.value, password.value);
      emit(LoginSuccess(user));
    } on ValidationException catch (e) {
      emit(LoginFailure(e.message));
    } on ServerException catch (e) {
      emit(LoginFailure(e.message));
    } catch (e) {
      debugPrint("Login Cubit ${e.toString()}");
      emit(LoginFailure("Unexpected error occurred"));
    }
  }
}
