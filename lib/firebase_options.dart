// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCBPlrYga-nVeLSdVh6D0I4yBAELRRmcI8',
    appId: '1:842618828625:web:71fd77b0fa8e69d0794570',
    messagingSenderId: '842618828625',
    projectId: 'xwitter-fa3c5',
    authDomain: 'xwitter-fa3c5.firebaseapp.com',
    storageBucket: 'xwitter-fa3c5.appspot.com',
    measurementId: 'G-Y3RCLSSHHJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjegW2oNbcd91BieWXIryTasz3FRe6oGM',
    appId: '1:842618828625:android:eb606ab43b463295794570',
    messagingSenderId: '842618828625',
    projectId: 'xwitter-fa3c5',
    storageBucket: 'xwitter-fa3c5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5XyrXsvTFUNcLpbHlpmNNh_okIzFC6YI',
    appId: '1:842618828625:ios:c3a51253a0247e6f794570',
    messagingSenderId: '842618828625',
    projectId: 'xwitter-fa3c5',
    storageBucket: 'xwitter-fa3c5.appspot.com',
    iosBundleId: 'com.example.xwitter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA5XyrXsvTFUNcLpbHlpmNNh_okIzFC6YI',
    appId: '1:842618828625:ios:c3a51253a0247e6f794570',
    messagingSenderId: '842618828625',
    projectId: 'xwitter-fa3c5',
    storageBucket: 'xwitter-fa3c5.appspot.com',
    iosBundleId: 'com.example.xwitter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCBPlrYga-nVeLSdVh6D0I4yBAELRRmcI8',
    appId: '1:842618828625:web:f2e3e5840d0c760d794570',
    messagingSenderId: '842618828625',
    projectId: 'xwitter-fa3c5',
    authDomain: 'xwitter-fa3c5.firebaseapp.com',
    storageBucket: 'xwitter-fa3c5.appspot.com',
    measurementId: 'G-GJ3QHEPQ92',
  );

}