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
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBLrbPrCj0ogtLeX4gR2CHpBX7luCacl2U',
    appId: '1:437464503053:web:ec84f28cb781b3487a5644',
    messagingSenderId: '437464503053',
    projectId: 'sf333-249cf',
    authDomain: 'sf333-249cf.firebaseapp.com',
    storageBucket: 'sf333-249cf.appspot.com',
    measurementId: 'G-YTSJ9J4W4H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOkMDD1dfLqmoOH40ooOKnDvFAhCyOe64',
    appId: '1:437464503053:android:cb05fed839ea5cbd7a5644',
    messagingSenderId: '437464503053',
    projectId: 'sf333-249cf',
    storageBucket: 'sf333-249cf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0SkhsFnGFXct-In_qowbNZJJFLhx7zqg',
    appId: '1:437464503053:ios:f4490c333ce5bafe7a5644',
    messagingSenderId: '437464503053',
    projectId: 'sf333-249cf',
    storageBucket: 'sf333-249cf.appspot.com',
    iosClientId: '437464503053-p72199pc1u24lfnnaqf2knpp92ai66bp.apps.googleusercontent.com',
    iosBundleId: 'com.example.paplerless',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0SkhsFnGFXct-In_qowbNZJJFLhx7zqg',
    appId: '1:437464503053:ios:f4490c333ce5bafe7a5644',
    messagingSenderId: '437464503053',
    projectId: 'sf333-249cf',
    storageBucket: 'sf333-249cf.appspot.com',
    iosClientId: '437464503053-p72199pc1u24lfnnaqf2knpp92ai66bp.apps.googleusercontent.com',
    iosBundleId: 'com.example.paplerless',
  );
}