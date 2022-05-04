import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String profileImageUrl;
  final int followers;
  final int following;
  final String bio;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
    required this.bio,
    String? name,
    String? photo,
  });

  static const User empty = User(
    id: '',
    username: '',
    email: '',
    profileImageUrl: '',
    followers: 0,
    following: 0,
    bio: '',
  );

  bool get isNotEmpty => this != User.empty;
  bool get isEmpty => this == User.empty;

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        profileImageUrl,
        followers,
        following,
        bio,
      ];

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    int? followers,
    int? following,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'userName': username,
      "email": email,
      "profileImageUrl": profileImageUrl,
      "followers": followers,
      "following": following,
      "bio": bio,
    };
  }

  factory User.fromDocument(DocumentSnapshot? doc) {
    final data = doc?.data() as Map<String, dynamic>?;

    if (doc == null || data == null) return User.empty;

    return User(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      followers: (data['followers'] ?? 0).toInt(),
      following: (data['following'] ?? 0).toInt(),
      bio: data['bio'] ?? '',
    );
  }

  // factory User.transform(auth.User? doc) {
  //   if (doc == null) return User.empty;

  //   return User(
  //     id: doc.id,
  //     username: data['username'] ?? '',
  //     email: data['email'] ?? '',
  //     profileImageUrl: data['profileImageUrl'] ?? '',
  //     followers: (data['followers'] ?? 0).toInt(),
  //     following: (data['following'] ?? 0).toInt(),
  //     bio: data['bio'] ?? '',
  //   );
  // }
}
