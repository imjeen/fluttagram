import 'package:fluttagram/screens/counter/counter_screen.dart';
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
      case NavScreen.routeName:
        return LoginScreen.route();
      // example: counter
      case CounterScreen.routName:
        return CounterScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text("Something went wrong"),
        ),
      ),
    );
  }
}
