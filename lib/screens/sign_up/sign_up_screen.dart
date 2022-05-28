import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/repositories/auth/auth_repository.dart';
import 'package:fluttagram/screens/login/login_screen.dart';
import 'package:fluttagram/screens/nav/nav_screen.dart';
import 'package:fluttagram/screens/sign_up/cubits/sign_up_cubit.dart';
import 'package:fluttagram/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const String routeName = "/signup";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SignUpScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            SignUpCubit(authRepository: context.read<AuthRepository>()),
        child: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  SignUpForm({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.status == SignUpStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            } else if (state.status == SignUpStatus.success) {
              if (context.read<AuthBloc>().state.status ==
                  AuthStatus.authenticated) {
                Navigator.of(context).pushReplacementNamed(NavScreen.routeName);
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
              // appBar: AppBar(title: const Text('')),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _signUpCard(context, state),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Card _signUpCard(BuildContext context, SignUpState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Instagram',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Username'),
                onChanged: (value) {
                  context.read<SignUpCubit>().userNameChanged(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  context.read<SignUpCubit>().emailChanged(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }

                  if (!value.contains('@')) {
                    return 'Please enter valid email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  context.read<SignUpCubit>().passwordChanged(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true &&
                      state.status != SignUpStatus.submitting) {
                    context.read<SignUpCubit>().signUpWithCredentials();
                  }
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.black,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  onSurface: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
