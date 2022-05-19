import 'dart:io';

abstract class BaseStoreRepository {
  Future<String> uploadProfileImage({required String url, required File image});
  Future<String> uploadPostImage({required File image});
}
