import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends UserEntity {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? name;

  const UserModel({
    required this.uid,
    required this.email,
    this.name,
  }) : super(uid: uid, email: email, name: name);

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
    };
  }
}
