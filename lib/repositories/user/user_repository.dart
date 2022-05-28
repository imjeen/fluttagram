import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttagram/enums/notify_type.dart';
import 'package:fluttagram/models/notify_model.dart';
import 'package:fluttagram/models/user_model.dart';
import 'package:fluttagram/repositories/user/base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  void followUser(
      {required String userId, required String followUserId}) async {
    // 将 跟随者 添加到 用户的跟随列表中
    _firebaseFirestore
        .collection('following')
        .doc(userId)
        .collection('userFollowing')
        .doc(followUserId)
        .set({});
    // 将 用户 添加到 追随者的跟随列表中
    _firebaseFirestore
        .collection('follower')
        .doc(followUserId)
        .collection('userFollowers')
        .doc(userId)
        .set({});

    final notification = Notify(
      type: NotifyType.follow,
      fromUser: User.empty.copyWith(id: userId),
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection('user')
        .doc(userId)
        .collection('userNotifications')
        .add(notification.toDocument());
  }

  @override
  Future<User> getUserWithId({required String userId}) async {
    final doc = await _firebaseFirestore.collection('users').doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<bool> isFollowing(
      {required String userId, required String otherUserId}) async {
    final otherUserDoc = await _firebaseFirestore
        .collection('following')
        .doc(userId)
        .collection('userFollowers')
        .doc(otherUserId)
        .get();

    return otherUserDoc.exists;
  }

  @override
  Future<List<User>> searchUsers({required String query}) async {
    final userSnap = await _firebaseFirestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .get();
    return userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  void unfollowUser({required String userId, required String unfollowUserId}) {
    // Remove unfollowUser from user's userFollowing.
    _firebaseFirestore
        .collection('following')
        .doc(userId)
        .collection('userFollowing')
        .doc(unfollowUserId)
        .delete();
    // Remove user from unfollowUser's userFollowers.
    _firebaseFirestore
        .collection('followers')
        .doc(unfollowUserId)
        .collection('userFollowers')
        .doc(userId)
        .delete();
  }

  @override
  Future<void> updateUser({required User user}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toDocument());
  }
}
