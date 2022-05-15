import 'package:fluttagram/custom_router.dart';
import 'package:fluttagram/enums/bottom_nav_item.dart';
import 'package:fluttagram/screens/create/bloc/create_bloc.dart';
import 'package:fluttagram/screens/create/create_screen.dart';
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
                    create: (_) => FeedBloc(),
                    child: const FeedScreen(),
                  );
                case BottomNavItem.search:
                  return BlocProvider(
                    create: (_) => SearchBloc(),
                    child: const SearchScreen(),
                  );
                case BottomNavItem.create:
                  return BlocProvider(
                    create: (_) => CreateBloc(),
                    child: const CreateScreen(),
                  );
                case BottomNavItem.notifications:
                  return BlocProvider(
                    create: (_) => NotificationsBloc(),
                    child: const NotificationsScreen(),
                  );
                case BottomNavItem.profile:
                  return BlocProvider(
                    create: (_) => ProfileBloc(),
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
