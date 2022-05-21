import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/cubits/cubits.dart';
import 'package:fluttagram/models/failure_model.dart';
import 'package:fluttagram/models/post_model.dart';
import 'package:fluttagram/models/user_model.dart';
import 'package:fluttagram/repositories/post/post_repository.dart';
import 'package:fluttagram/repositories/user/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  ProfileBloc({
    required UserRepository userRepository,
    required PostRepository postRepository,
    required AuthBloc authBloc,
    required LikedPostsCubit likedPostsCubit,
  })  : _userRepository = userRepository,
        _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(ProfileState.initial()) {
    on<ProfileLoadUser>(_profileLoadUser);
    on<ProfileToggleGridView>(_profileToggleGridView);
    on<ProfileUpdatePosts>(_profileUpdatePosts);
    on<ProfileFollowUser>(_profileFollowUser);
    on<ProfileUnfollowUser>(_profileUnfollowUser);
  }

  StreamSubscription<List<Future<Post?>>>? _postsSubscription;

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }

  void _profileLoadUser(
    ProfileLoadUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.id == user.id;
      final isFollowing = await _userRepository.isFollowing(
        userId: _authBloc.state.user.id,
        otherUserId: event.userId,
      );
      //subscription
      _postsSubscription?.cancel();
      _postsSubscription = _postRepository
          .getPostsByUserId(userId: event.userId)
          .listen((post) async {
        final allPosts = await Future.wait(post);
        add(ProfileUpdatePosts(posts: allPosts.whereType<Post>().toList()));
      });

      emit(state.copyWith(
        isCurrentUser: isCurrentUser,
        isFollowing: isFollowing,
        status: ProfileStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'unable load profile'),
      ));
    }
  }

  void _profileToggleGridView(
    ProfileToggleGridView event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(isGridView: event.isGridView));
  }

  void _profileUpdatePosts(
    ProfileUpdatePosts event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(posts: event.posts));
      final likedPostIds = await _postRepository.getUserLikedPostIds(
        posts: event.posts,
        userId: _authBloc.state.user.id,
      );

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
    } catch (e) {
      print(e);
    }
  }

  void _profileFollowUser(
    ProfileFollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      _userRepository.followUser(
        userId: _authBloc.state.user.id,
        followUserId: state.user.id,
      );
      final updatedUser =
          state.user.copyWith(followers: state.user.followers + 1);
      emit(state.copyWith(user: updatedUser, isFollowing: true));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'Something went wrong'),
      ));
    }
  }

  void _profileUnfollowUser(
    ProfileUnfollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      _userRepository.unfollowUser(
        userId: _authBloc.state.user.id,
        unfollowUserId: state.user.id,
      );
      final updatedUser =
          state.user.copyWith(followers: state.user.followers - 1);
      emit(state.copyWith(user: updatedUser, isFollowing: false));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'Something went wrong'),
      ));
    }
  }
}
