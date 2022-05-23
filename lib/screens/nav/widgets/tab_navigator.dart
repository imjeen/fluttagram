import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/cubits/cubits.dart';
import 'package:fluttagram/custom_router.dart';
import 'package:fluttagram/enums/bottom_nav_item.dart';
import 'package:fluttagram/repositories/post/post_repository.dart';
import 'package:fluttagram/repositories/storage/storage_repository.dart';
import 'package:fluttagram/repositories/user/user_repository.dart';
import 'package:fluttagram/screens/create_post/create_post_screen.dart';
import 'package:fluttagram/screens/create_post/cubit/create_post_cubit.dart';
import 'package:fluttagram/screens/feed/bloc/feed_bloc.dart';
import 'package:fluttagram/screens/feed/feed_screen.dart';
import 'package:fluttagram/screens/notifications/bloc/notifications_bloc.dart';
import 'package:fluttagram/screens/notifications/notifications_screen.dart';
import 'package:fluttagram/screens/profile/bloc/profile_bloc.dart';
import 'package:fluttagram/screens/profile/profile_screen.dart';
import 'package:fluttagram/screens/search/bloc/search_bloc.dart';
import 'package:fluttagram/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoute = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({Key? key, required this.navigatorKey, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoute,
      onGenerateRoute: CustomRouter.onGenerateNestRoute,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: const RouteSettings(name: tabNavigatorRoute),
            builder: (context) {
              switch (item) {
                case BottomNavItem.feed:
                  return BlocProvider(
                    create: (_) => FeedBloc(
                        authBloc: context.read<AuthBloc>(),
                        postRepository: context.read<PostRepository>(),
                        likedPostsCubit: context.read<LikedPostsCubit>())
                      ..add(FeedFetchPosts()),
                    child: const FeedScreen(),
                  );
                case BottomNavItem.search:
                  return BlocProvider(
                    create: (_) => SearchBloc(),
                    child: const SearchScreen(),
                  );
                case BottomNavItem.create:
                  return BlocProvider(
                    create: (_) => CreatePostCubit(
                      authBloc: context.read<AuthBloc>(),
                      postRepository: context.read<PostRepository>(),
                      storageRepository: context.read<StorageRepository>(),
                    ),
                    child: CreatePostScreen(),
                  );
                case BottomNavItem.notifications:
                  return BlocProvider(
                    create: (_) => NotificationsBloc(),
                    child: const NotificationsScreen(),
                  );
                case BottomNavItem.profile:
                  return BlocProvider(
                    create: (_) => ProfileBloc(
                      authBloc: context.read<AuthBloc>(),
                      userRepository: context.read<UserRepository>(),
                      postRepository: context.read<PostRepository>(),
                      likedPostsCubit: context.read<LikedPostsCubit>(),
                    )..add(ProfileLoadUser(
                        userId: context.read<AuthBloc>().state.user.id)),
                    child: const ProfileScreen(),
                  );
              }
            },
          )
        ];
      },
    );
  }
}
