import 'package:fluttagram/models/comment_model.dart';
import 'package:fluttagram/models/post_model.dart';

abstract class BasePostRepository {
  Future<void> createPost({required Post post});
  Future<void> createComment({required Post post, required Comment comment});
  void createLike({required Post post, required String userId});
  void deleteLike({required String postId, required String userId});
  Stream<List<Future<Post?>>> getPostsByUserId({required String userId});
  Stream<List<Future<Comment?>>> getCommentsByPostId({required String postId});
  Future<List<Post>> getUserPostFeed(
      {required String userId, String? lastPostId});
  Future<Set<String>> getUserLikedPostIds(
      {required String userId, required List<Post> posts});
  // getPostLikes({String userId, post});
}
