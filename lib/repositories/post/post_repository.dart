import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttagram/enums/notification_type.dart';
import 'package:fluttagram/models/notification_model.dart';
import 'package:fluttagram/models/post_model.dart';
import 'package:fluttagram/models/comment_model.dart';
import 'package:fluttagram/models/user_model.dart';
import 'package:fluttagram/repositories/post/base_post_repository.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createComment(
      {required Post post, required Comment comment}) async {
    _firebaseFirestore
        .collection('comments')
        .doc(comment.postId)
        .collection('postComments')
        .add(post.toDocument());

    final notification = Notification(
      type: NotificationType.comment,
      fromUser: comment.author,
      date: DateTime.now(),
      post: post,
    );

    _firebaseFirestore
        .collection('notifications')
        .doc(comment.author.id)
        .collection('userNotifications')
        .add(notification.toDocument());
  }

  @override
  void createLike({required Post post, required String userId}) {
    _firebaseFirestore
        .collection('posts')
        .doc(post.id)
        .update({'likes': FieldValue.increment(1)});

    _firebaseFirestore
        .collection('likes')
        .doc(post.id)
        .collection('postLikes')
        .doc(userId)
        .set({});

    final notification = Notification(
      type: NotificationType.like,
      fromUser: User.empty.copyWith(id: userId),
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection('likes')
        .doc(post.author.id)
        .collection('userNotifications')
        .add(notification.toDocument());
  }

  @override
  Future<void> createPost({required Post post}) async {
    await _firebaseFirestore.collection('posts').add(post.toDocument());
  }

  @override
  void deleteLike({required String postId, required String userId}) async {
    _firebaseFirestore
        .collection('posts')
        .doc(postId)
        .update({'likes': FieldValue.increment(-1)});

    _firebaseFirestore
        .collection('likes')
        .doc(postId)
        .collection('postLikes')
        .doc(userId)
        .delete();
  }

  @override
  Stream<List<Future<Comment?>>> getCommentsByPostId({required String postId}) {
    return _firebaseFirestore
        .collection('comments')
        .doc(postId)
        .collection('postComments')
        .orderBy('date', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Comment.fromDocument(doc)).toList(),
        );
  }

  @override
  Stream<List<Future<Post?>>> getPostsByUserId({required String userId}) {
    final authorRef = _firebaseFirestore.collection('users').doc(userId);
    return _firebaseFirestore
        .collection('posts')
        .where('author', isEqualTo: authorRef)
        .orderBy('date', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Post.fromDocument(doc)).toList(),
        );
  }

  @override
  Future<Set<String>> getUserLikedPostIds(
      {required String userId, required List<Post> posts}) async {
    final postIds = <String>{};
    for (final post in posts) {
      final likeDoc = await _firebaseFirestore
          .collection('likes')
          .doc(post.id)
          .collection('postLikes')
          .doc(userId)
          .get();
      if (likeDoc.exists) {
        postIds.add(post.id);
      }
    }
    return postIds;
  }

  @override
  Future<List<Post?>> getUserPostFeed(
      {required String userId, String? lastPostId}) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection('feeds')
          .doc(userId)
          .collection('userFeed')
          .orderBy('date', descending: true)
          .limit(3)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection('feeds')
          .doc(userId)
          .collection('userFeed')
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection('feeds')
          .doc(userId)
          .collection('userFeed')
          .orderBy('date', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(3)
          .get();
    }

    return Future.wait(
      postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList(),
    );
  }
}