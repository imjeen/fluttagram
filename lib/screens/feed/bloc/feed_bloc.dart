import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:fluttagram/models/failure_model.dart';
import 'package:fluttagram/models/post_model.dart';
import 'package:fluttagram/repositories/post/post_repository.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final AuthBloc _authBloc;
  final PostRepository _postRepository;
  final LikedPostsCubit _likedPostsCubit;

  FeedBloc({
    required AuthBloc authBloc,
    required PostRepository postRepository,
    required LikedPostsCubit likedPostsCubit,
  })  : _authBloc = authBloc,
        _postRepository = postRepository,
        _likedPostsCubit = likedPostsCubit,
        super(FeedState.initial()) {
    // on<FeedEvent>((event, emit) {});

    on<FeedFetchPosts>(_feedFetchPosts);
    on<FeedPaginatePosts>(_feedPaginatePosts);
  }

  _feedFetchPosts(FeedFetchPosts event, Emitter<FeedState> emit) async {
    emit(state.copyWith(posts: [], status: FeedStatus.loading));
    try {
      // final posts = await _postRepository.getUserPostFeed(
      //   userId: _authBloc.state.user.id,
      // );
      final posts = await _postRepository.getPosts();

      // print('[_feedFetchPosts] posts=${posts}');

      _likedPostsCubit.clearAllLikedPosts();

      final likedPostIds = await _postRepository.getUserLikedPostIds(
        userId: _authBloc.state.user.id,
        posts: posts,
      );
      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      emit(state.copyWith(posts: posts, status: FeedStatus.loaded));
    } catch (err) {
      // print('_feedFetchPosts ${err}');
      emit(state.copyWith(
        status: FeedStatus.error,
        failure: const Failure(message: 'Unable to load your feed.'),
      ));
    }
  }

  _feedPaginatePosts(FeedPaginatePosts event, Emitter<FeedState> emit) async {
    emit(state.copyWith(status: FeedStatus.paginating));

    try {
      print('state.posts=${state.posts}');
      final lastPostId = state.posts.isNotEmpty ? state.posts.last.id : null;
      // final posts = await _postRepository.getUserPostFeed(
      //   userId: _authBloc.state.user.id,
      //   lastPostId: lastPostId,
      // );
      final posts = await _postRepository.getPosts(
        lastPostId: lastPostId,
      );

      final updatedPosts = List<Post>.from(state.posts)..addAll(posts);
      final likedPostIds = await _postRepository.getUserLikedPostIds(
        userId: _authBloc.state.user.id,
        posts: posts,
      );
      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      emit(state.copyWith(posts: updatedPosts, status: FeedStatus.loaded));
    } catch (err) {
      // print('_feedPaginatePosts #error ${FeedStatus.error}');
      emit(state.copyWith(
        status: FeedStatus.error,
        failure: const Failure(message: 'Unable to load your paginated feeds.'),
      ));
    }
  }
}
