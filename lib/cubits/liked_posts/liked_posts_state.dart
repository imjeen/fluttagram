part of 'liked_posts_cubit.dart';

class LikedPostsState extends Equatable {
  final Set<String> likedPostIds;
  final Set<String> recentLyLikedPostIds;

  const LikedPostsState({
    required this.likedPostIds,
    required this.recentLyLikedPostIds,
  });

  factory LikedPostsState.initial() {
    return const LikedPostsState(likedPostIds: {}, recentLyLikedPostIds: {});
  }

  @override
  List<Object?> get props => [likedPostIds, recentLyLikedPostIds];

  LikedPostsState copyWith({
    Set<String>? likedPostIds,
    Set<String>? recentLyLikedPostIds,
  }) {
    return LikedPostsState(
      likedPostIds: likedPostIds ?? this.likedPostIds,
      recentLyLikedPostIds: recentLyLikedPostIds ?? this.recentLyLikedPostIds,
    );
  }
}
