import 'package:fluttagram/models/notification_model.dart';

abstract class BaseNotificationRepository {
  Stream<List<Future<Notification?>>> getUserNotifications({required String userId});
}
