import 'package:fluttagram/models/notify_model.dart';

abstract class BaseNotifyRepository {
  Stream<List<Future<Notify?>>> getUserNotifications({required String userId});
}
