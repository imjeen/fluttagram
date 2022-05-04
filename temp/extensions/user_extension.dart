// ignore_for_file: unused_element

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fluttagram/models/user_model.dart';

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
