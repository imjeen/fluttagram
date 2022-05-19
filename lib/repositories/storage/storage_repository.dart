import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'base_storage_repository.dart';

class StoreRepository extends BaseStoreRepository {
  final FirebaseStorage _firebaseStorage;

  StoreRepository({FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<String> _uploadImage({
    required File image,
    required String ref,
  }) async {
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(image)
        .then((snap) => snap.ref.getDownloadURL());

    return downloadUrl;
  }

  @override
  Future<String> uploadPostImage({required File image}) async {
    final imageId = Uuid().v4();

    final downloadUrl = await _uploadImage(
      image: image,
      ref: 'image/posts/post_$imageId.jpg',
    );

    return downloadUrl;
  }

  @override
  Future<String> uploadProfileImage(
      {required String url, required File image}) async {
    String? imageId = Uuid().v4();

    if (url.isNotEmpty) {
      final exp = RegExp(r'userProfile_.*.jpg');
      imageId = exp.firstMatch(url)?[1];
    }

    final downloadUrl = await _uploadImage(
      image: image,
      ref: 'image/users/userProfile_$imageId.jpg',
    );

    return downloadUrl;
  }
}
