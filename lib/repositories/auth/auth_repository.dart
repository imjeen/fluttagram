import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttagram/models/failure_model.dart';
import 'package:fluttagram/models/user_model.dart';
import './base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({
    FirebaseFirestore? firebaseFirestore,
    auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((fireUser) {
      final user = fireUser == null ? User.empty : fireUser.toUser;
      return user;
    });
  }

  @override
  Future<User> signUpWithEmailAndPassword({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final credentialUser = credential.user!;

      final user = User.empty.copyWith(
        id: credentialUser.uid,
        username: userName,
        email: email,
      );
      await _firebaseFirestore
          .collection('users')
          .doc(credentialUser.uid)
          .set(user.toDocument());

      return user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message ?? '');
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message ?? '');
    }
  }

  @override
  Future<auth.User> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      return user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message ?? '');
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message ?? '');
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}

extension on auth.User {
  User get toUser {
    return User(
      id: uid,
      username: displayName ?? '',
      email: email ?? '',
      bio: '',
      followers: 0,
      following: 0,
      profileImageUrl: photoURL ?? '',
    );
  }
}
