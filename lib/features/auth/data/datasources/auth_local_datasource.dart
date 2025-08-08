import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);

  Future<UserModel?> getUser();

  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _userBoxName = 'userBox';

  @override
  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    await box.put('user', user);
    debugPrint("Logged in user: ${user?.name} (${user?.email})");
  }

  @override
  Future<UserModel?> getUser() async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    return box.get('user');
  }

  @override
  Future<void> clearUser() async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    await box.clear();
  }
}
