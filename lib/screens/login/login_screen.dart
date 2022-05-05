import 'package:fluttagram/repositories/auth/auth_repository.dart';
import 'package:fluttagram/screens/login/cubits/login_cubit.dart';
import 'package:fluttagram/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = "/login";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(''),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _loginCard(context, state),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Card _loginCard(BuildContext context, LoginState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Instagram',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
              TextField(
                decoration: const InputDecoration(hintText: 'Email'),
                onChanged: (value) =>
                    context.read<LoginCubit>().emailChanged(value: value),
              ),
              const SizedBox(height: 16.0),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
                onChanged: (value) =>
                    context.read<LoginCubit>().passwordChanged(value: value),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 5.0),
                onPressed: () => {
                  if (_formKey.currentState?.validate() != true &&
                      state.status != LoginStatus.submitting)
                    {context.read<LoginCubit>().logInWithCredentials()}
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.black,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  onSurface: Colors.transparent,
                ),
                onPressed: () {
                  // TODO: to sign up
                },
                child: const Text('No Account ? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
