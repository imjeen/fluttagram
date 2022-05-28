import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fluttagram/models/user_model.dart';

abstract class BaseAuthRepository {
  Stream<User> get user;
  // 注册
  Future<User> signUpWithEmailAndPassword({
    required String userName,
    required String email,
    required String password,
  });
  // 登陆
  Future<auth.User> logInWithEmailAndPassword({
    required String email,
    required String password,
  });
  // 登出
  Future<void> logOut();
}
