import 'package:daily_expense_tracker/core/error/exceptions.dart';
import 'package:daily_expense_tracker/features/auth/presentation/auth/register/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/register_usecase.dart';
// import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({required this.registerUseCase}) : super(RegisterInitial());

  Future<void> register(String email, String password, String? name) async {
    emit(RegisterLoading());
    try {
      final user = await registerUseCase(email, password, name: name);
      emit(RegisterSuccess(user));
    } on ValidationException catch (e) {
      emit(RegisterFailure(e.message));
    } on ServerException catch (e) {
      debugPrint("Register cubit ${e.message}");
      emit(RegisterFailure("Unexpected error occurred"));
      // emit(RegisterFailure(e.toString()));
    }
  }
}
