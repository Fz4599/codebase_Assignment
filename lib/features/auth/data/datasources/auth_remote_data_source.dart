import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> signUp(
    String email,
    String password, {
    String? name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;
      final userModel = UserModel(uid: uid, email: email, name: name);

      await _firestore.collection('users').doc(uid).set(userModel.toMap());
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Sign up failed');
    } catch (_) {
      throw ServerException('Unexpected error during sign up');
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;
      final snapshot = await _firestore.collection('users').doc(uid).get();

      return UserModel.fromMap(snapshot.data()!, uid);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Login failed');
    } catch (_) {
      throw ServerException('Unexpected error during login');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    return UserModel.fromMap(snapshot.data()!, user.uid);
  }
}
