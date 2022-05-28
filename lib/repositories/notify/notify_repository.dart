import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttagram/models/notify_model.dart';

import 'base_notify_repository.dart';

class NotifyRepository extends BaseNotifyRepository {
  final FirebaseFirestore _firebaseFirestore;

  NotifyRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Future<Notify?>>> getUserNotifications(
      {required String userId}) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('userNotifications')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Notify.fromDocument(doc)).toList(),
        );
  }
}
