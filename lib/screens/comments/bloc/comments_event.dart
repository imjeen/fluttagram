part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

// 获取
class CommentsFetchPost extends CommentsEvent {
  final Post post;
  const CommentsFetchPost({required this.post});
  @override
  List<Object> get props => [post];
}

// 更新
class CommentsUpdateComments extends CommentsEvent {
  final List<Comment> comments;
  const CommentsUpdateComments({required this.comments});
  @override
  List<Object> get props => [comments];
}

// 提交
class CommentsPostComment extends CommentsEvent {
  final String content;
  const CommentsPostComment({required this.content});
  @override
  List<Object> get props => [content];
}
