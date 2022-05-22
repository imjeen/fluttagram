import 'package:fluttagram/enums/bottom_nav_item.dart';
import 'package:fluttagram/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:fluttagram/screens/nav/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavScreen extends StatelessWidget {
  NavScreen({Key? key}) : super(key: key);

  static const String routeName = "/nav";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => NavScreen(),
    );
  }

  final Map<BottomNavItem, IconData> items = {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notifications: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle
  };

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notifications: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
          create: (_) => BottomNavBarCubit(),
          child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
              builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: items
                    .map((item, _) => MapEntry(
                        item,
                        Offstage(
                          offstage: item != state.selectedItem,
                          child: TabNavigator(
                            navigatorKey: navigatorKeys[item]!,
                            item: item,
                          ),
                        )))
                    .values
                    .toList(),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.grey,
                currentIndex: BottomNavItem.values.indexOf(state.selectedItem),
                items: items
                    .map(
                      (item, icon) => MapEntry(
                        item.toString(),
                        BottomNavigationBarItem(
                            label: '', icon: Icon(icon, size: 30.0)),
                      ),
                    )
                    .values
                    .toList(),
                onTap: (index) {
                  final selectedItem = BottomNavItem.values[index];
                  if (selectedItem == state.selectedItem) {
                    navigatorKeys[selectedItem]
                        ?.currentState
                        ?.popUntil((route) => route.isFirst);
                  }
                  context
                      .read<BottomNavBarCubit>()
                      .updateSelectedItem(selectedItem);
                },
              ),
            );
          })),
    );
  }
}
