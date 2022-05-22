import 'package:fluttagram/screens/counter/counter_screen.dart';
import 'package:fluttagram/screens/edit_profile/edit_profile_screen.dart';
import 'package:fluttagram/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttagram/screens/login/login_screen.dart';
import 'package:fluttagram/screens/nav/nav_screen.dart';
import 'package:fluttagram/screens/splash/splash_screen.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case SignUpScreen.routeName:
        return SignUpScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      // example: counter
      case CounterScreen.routName:
        return CounterScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestRoute(RouteSettings settings) {
    switch (settings.name) {
      case EditProfileScreen.routeName:
        return EditProfileScreen.route(
          args: settings.arguments as EditProfileScreenArgs,
        );
      default:
        return _errorRoute(text: 'nested route');
    }
  }

  static Route _errorRoute({String? text}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text('Something went wrong! ${text ?? ""}'),
        ),
      ),
    );
  }
}
