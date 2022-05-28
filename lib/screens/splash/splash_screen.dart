import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/screens/login/login_screen.dart';
import 'package:fluttagram/screens/nav/nav_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routName),
      builder: (_) => const SplashScreen(),
    );
  }

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              Navigator.of(context).pushNamed(NavScreen.routeName);
            } else {
              // to login
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            }
          },
          child: const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ));
  }
}
