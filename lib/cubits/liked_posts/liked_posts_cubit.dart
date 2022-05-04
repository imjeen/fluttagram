import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/models/post_model.dart';
import 'package:fluttagram/repositories/post/post_repository.dart';

part 'liked_posts_state.dart';

class LikedPostsCubit extends Cubit<LikedPostsState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  LikedPostsCubit({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        super(LikedPostsState.initial());

  void likePost({required Post post}) {
    _postRepository.createLike(
      post: post,
      userId: _authBloc.state.user.id,
    );

    emit(state.copyWith(
      likedPostIds: Set<String>.from(state.likedPostIds)..add(post.id),
      recentLyLikedPostIds: Set<String>.from(state.recentLyLikedPostIds)
        ..add(post.id),
    ));
  }

  void unlikePost({required Post post}) {
    _postRepository.deleteLike(
      postId: post.id,
      userId: _authBloc.state.user.id,
    );
    emit(state.copyWith(
      likedPostIds: Set<String>.from(state.likedPostIds)..remove(post.id),
      recentLyLikedPostIds: Set<String>.from(state.recentLyLikedPostIds)
        ..remove(post.id),
    ));
  }

  void updateLikedPosts({required Set<String> postIds}) {
    emit(state.copyWith(
      likedPostIds: Set<String>.from(state.likedPostIds)..addAll(postIds),
    ));
  }

  void clearAllLikedPosts() {
    emit(LikedPostsState.initial());
  }
}
