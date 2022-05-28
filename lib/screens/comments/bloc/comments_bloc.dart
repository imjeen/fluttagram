import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/models/comment_model.dart';
import 'package:fluttagram/models/failure_model.dart';
import 'package:fluttagram/models/post_model.dart';
import 'package:fluttagram/models/user_model.dart';
import 'package:fluttagram/repositories/post/post_repository.dart';
import 'package:uuid/uuid.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final AuthBloc authBloc;
  final PostRepository postRepository;

  CommentsBloc({
    required this.authBloc,
    required this.postRepository,
  }) : super(CommentsState.initial()) {
    on<CommentsFetchPost>(_commentsFetchPost);
    on<CommentsUpdateComments>(_commentsUpdateComments);
    on<CommentsPostComment>(_commentsPostComment);
  }

  StreamSubscription<List<Future<Comment?>>>? _commentsSubscription;

  @override
  Future<void> close() {
    _commentsSubscription?.cancel();
    return super.close();
  }

  void _commentsFetchPost(
    CommentsFetchPost event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(status: CommentsStatus.loading));
    try {
      _commentsSubscription?.cancel();

      _commentsSubscription =
          postRepository.getCommentsByPostId(postId: event.post.id).listen(
        (comments) async {
          final allComments = await Future.wait(comments);
          add(CommentsUpdateComments(
            comments: allComments.whereType<Comment>().toList(),
          ));
        },
      );

      emit(state.copyWith(status: CommentsStatus.loaded, post: event.post));
    } catch (e) {
      emit(state.copyWith(
        status: CommentsStatus.error,
        failure: const Failure(message: 'unable fetch comment'),
      ));
    }
  }

  void _commentsUpdateComments(
    CommentsUpdateComments event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(comments: event.comments));
  }

  void _commentsPostComment(
    CommentsPostComment event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(status: CommentsStatus.submitting));
    try {
      final author = User.empty.copyWith(id: authBloc.state.user.id);
      final comment = Comment(
        id: Uuid().v4(),
        postId: state.post!.id,
        author: author,
        content: event.content,
        date: DateTime.now(),
      );
      await postRepository.createComment(
        comment: comment,
        post: state.post!,
      );
      emit(state.copyWith(status: CommentsStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: CommentsStatus.error,
        failure: const Failure(message: 'unable post comment'),
      ));
    }
  }
}
