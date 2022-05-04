import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = "/login";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   title: const Text(''),
      // ),
      body: Center(
        child: Text('login screen'),
      ),
    );
  }
}
