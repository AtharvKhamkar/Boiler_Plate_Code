// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:ask_qx/global/app_storage.dart';
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AppStorage.isDevBuild()?androidDev:androidProduction;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  //production
  //1:1090618450548:android:0480580da6847cb688e721

  //dev
  //1:1090618450548:android:cf4ede6419d0bdaf88e721

  static const FirebaseOptions androidProduction = FirebaseOptions(
    apiKey: 'AIzaSyCkXRaOnCGwlaRwvx2vCmTprTsPMP8cy-Y',//'AIzaSyBqrmrnTfD2-XnjcDEY1-4nhyTPeBmKU98',
    appId: '1:1090618450548:android:0480580da6847cb688e721',
    messagingSenderId: '1090618450548',
    projectId: 'qxlabai-dashboard',
  );
  static const FirebaseOptions androidDev = FirebaseOptions(
    apiKey: 'AIzaSyCkXRaOnCGwlaRwvx2vCmTprTsPMP8cy-Y',//'AIzaSyBqrmrnTfD2-XnjcDEY1-4nhyTPeBmKU98',
    appId: '1:1090618450548:android:cf4ede6419d0bdaf88e721',
    messagingSenderId: '1090618450548',
    projectId: 'qxlabai-dashboard',

  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCkXRaOnCGwlaRwvx2vCmTprTsPMP8cy-Y',//'AIzaSyCMQkMWa2cY32ripAAPQn9sdtQEqt2D4lU',
    appId: '1:1090618450548:ios:d1be3f8cb1f1d56388e721',
    messagingSenderId: '1090618450548',
    projectId: 'qxlabai-dashboard',
    storageBucket: 'ask-qx.appspot.com',
    iosBundleId: 'com.qxlabai.askqx',
  );
}