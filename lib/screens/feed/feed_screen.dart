import 'package:fluttagram/cubits/liked_posts/liked_posts_cubit.dart';
// import 'package:fluttagram/models/post_model.dart';
// import 'package:fluttagram/repositories/post/post_repository.dart';
import 'package:fluttagram/screens/feed/bloc/feed_bloc.dart';
import 'package:fluttagram/widgets/error_dialog.dart';
import 'package:fluttagram/widgets/post_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = "/feed";

  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<FeedBloc>().state.status != FeedStatus.paginating) {
          context.read<FeedBloc>().add(FeedPaginatePosts());
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Instagram'),
        ),
        body: _body(state),
      );
    }, listener: (context, state) {
      if (state.status == FeedStatus.error) {
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(content: state.failure.message),
        );
      } else if (state.status == FeedStatus.paginating) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Fetching More Posts...'),
          ),
        );
      }
    });
  }

  Widget _body(FeedState state) {
    if (state.status == FeedStatus.loading) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 20.0),
          Text('loading...'),
        ],
      ));
    }

    return RefreshIndicator(
        onRefresh: () async {
          context.read<FeedBloc>().add(FeedFetchPosts());
          context.read<LikedPostsCubit>().clearAllLikedPosts();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: state.posts.length,
          itemBuilder: (context, index) {
            final post = state.posts[index];
            final likedPostsState = context.watch<LikedPostsCubit>().state;
            final liked = likedPostsState.likedPostIds.contains(post.id);
            final recentlyLiked =
                likedPostsState.recentLyLikedPostIds.contains(post.id);
            return PostView(
              post: post,
              recentlyLiked: recentlyLiked,
              liked: liked,
              onLike: () {
                // TODO
                if (liked) {
                  context.read<LikedPostsCubit>().unlikePost(post: post);
                } else {
                  context.read<LikedPostsCubit>().likePost(post: post);
                }
              },
            );
          },
        ));
  }
}
