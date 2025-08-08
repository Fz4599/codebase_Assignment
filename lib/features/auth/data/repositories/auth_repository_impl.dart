import 'package:daily_expense_tracker/features/auth/data/datasources/auth_local_datasource.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.dataSource, this.localDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    final user = await dataSource.login(email, password);
    await localDataSource.saveUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUser();
    return dataSource.logout();
  }

  @override
  Future<bool> isLoggedIn() {
    return dataSource.isLoggedIn();
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return dataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> signUp(String email, String password, {String? name}) {
    return dataSource.signUp(email, password, name: name);
  }
}
