import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttagram/models/notification_model.dart';

import 'base_notification_repository.dart';

class NotificationRepository extends BaseNotificationRepository {
  final FirebaseFirestore _firebaseFirestore;

  NotificationRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Future<Notification?>>> getUserNotifications(
      {required String userId}) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('userNotifications')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Notification.fromDocument(doc)).toList(),
        );
  }
}
