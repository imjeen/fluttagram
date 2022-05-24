import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:fluttagram/screens/login/login_screen.dart';
import 'package:fluttagram/screens/profile/bloc/profile_bloc.dart';
import 'package:fluttagram/screens/profile/widget/profile_stats.dart';
import 'package:fluttagram/widgets/error_dialog.dart';
import 'package:fluttagram/widgets/post_view.dart';
import 'package:fluttagram/widgets/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ProfileScreen(),
    );
  }

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user.username),
            actions: [
              if (state.isCurrentUser)
                IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    context.read<LikedPostsCubit>().clearAllLikedPosts();
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil(
                      LoginScreen.routeName,
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: const Icon(Icons.exit_to_app),
                )
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state.status == ProfileStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(ProfileLoadUser(userId: state.user.id));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0),
                  child: Row(
                    children: [
                      UserProfileImage(avatarUrl: state.user.profileImageUrl),
                      ProfileStats(
                        isCurrentUser: state.isCurrentUser,
                        isFollowing: state.isFollowing,
                        posts: state.posts.length,
                        followers: state.user.followers,
                        following: state.user.following,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.grid_on, size: 28.0)),
                Tab(icon: Icon(Icons.list, size: 28.0)),
              ],
              indicatorWeight: 3.0,
              onTap: (i) {
                context
                    .read<ProfileBloc>()
                    .add(ProfileToggleGridView(isGridView: i == 0));
              },
            ),
          ),
          state.isGridView
              ? SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = state.posts[index];
                      return GestureDetector(
                        onTap: () {
                          // TODO
                        },
                        child: CachedNetworkImage(
                          imageUrl: post.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    childCount: state.posts.length,
                  ))
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final post = state.posts[index];

                    final likedPostsState =
                        context.read<LikedPostsCubit>().state;
                    final isLiked =
                        likedPostsState.likedPostIds.contains(post.id);
                    return PostView(
                      post: post,
                      liked: isLiked,
                      onLike: () {
                        if (isLiked) {
                          context
                              .read<LikedPostsCubit>()
                              .unlikePost(post: post);
                        } else {
                          context.read<LikedPostsCubit>().likePost(post: post);
                        }
                      },
                    );
                  }, childCount: state.posts.length),
                )
        ],
      ),
    );
  }
}
