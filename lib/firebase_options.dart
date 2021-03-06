// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAtUvTskqbCM7n19mIOzLGdFrt2bTo1dA4',
    appId: '1:610333240129:web:9f91e10bd2dabf70814fc0',
    messagingSenderId: '610333240129',
    projectId: 'fluttagram-91d94',
    authDomain: 'fluttagram-91d94.firebaseapp.com',
    storageBucket: 'fluttagram-91d94.appspot.com',
    measurementId: 'G-0TBHYLQCPM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRx5Eu6O3zB2GJskLwiMXz-hSkTATAryg',
    appId: '1:610333240129:android:e87989840c50857b814fc0',
    messagingSenderId: '610333240129',
    projectId: 'fluttagram-91d94',
    storageBucket: 'fluttagram-91d94.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBo0U9mQFod6FluwCIu7ZwXUZ58yIItpqg',
    appId: '1:610333240129:ios:68a301f0b1361e5b814fc0',
    messagingSenderId: '610333240129',
    projectId: 'fluttagram-91d94',
    storageBucket: 'fluttagram-91d94.appspot.com',
    iosClientId: '610333240129-6i4b58rklt5kk73am4t2a26dpmveuvav.apps.googleusercontent.com',
    iosBundleId: 'com.example.fluttagram',
  );
}
