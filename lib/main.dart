import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/blocs/simple_bloc_observer.dart';
import 'package:fluttagram/cubits/cubits.dart';
import 'package:fluttagram/custom_router.dart';
import 'package:fluttagram/repositories/auth/auth_repository.dart';
import 'package:fluttagram/repositories/notification/notification_repository.dart';
import 'package:fluttagram/repositories/post/post_repository.dart';
import 'package:fluttagram/repositories/user/user_repository.dart';
// import 'package:fluttagram/screens/count/count_screen.dart';
import 'package:fluttagram/screens/splash/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // fix main async
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => UserRepository()),
        RepositoryProvider(create: (_) => PostRepository()),
        RepositoryProvider(create: (_) => NotificationRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => LikedPostsCubit(
              postRepository: context.read<PostRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          )
        ],
        child: MaterialApp(
          title: 'Instagram',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[50],
          ),
          // home: const CountScreen(title: 'Instagram'),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routName,
        ),
      ),
    );
  }
}
