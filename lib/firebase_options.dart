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
    apiKey: 'AIzaSyBSovbhQ-gf_Gr7vJoCsn12YapiRTPBBBQ',
    appId: '1:688032127071:web:49134ae8a40047b8c2e3ea',
    messagingSenderId: '688032127071',
    projectId: 'swaminarayanstatus-f8550',
    authDomain: 'swaminarayanstatus-f8550.firebaseapp.com',
    storageBucket: 'swaminarayanstatus-f8550.appspot.com',
    measurementId: 'G-YRZZ8FF2P9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDw1A-FIaJkab2CKboh9xfoQqlMe3Nry6g',
    appId: '1:688032127071:android:3920ea3363f28fe1c2e3ea',
    messagingSenderId: '688032127071',
    projectId: 'swaminarayanstatus-f8550',
    storageBucket: 'swaminarayanstatus-f8550.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBr26ih0rwKJR1jO7w6c8K6EroqqBBcy5U',
    appId: '1:688032127071:ios:983c8406f8446d69c2e3ea',
    messagingSenderId: '688032127071',
    projectId: 'swaminarayanstatus-f8550',
    storageBucket: 'swaminarayanstatus-f8550.appspot.com',
    iosClientId: '688032127071-h70v4cmn466cdtldm2u9ij57q9du78ua.apps.googleusercontent.com',
    iosBundleId: 'com.mobileappxperts.swaminarayanstatus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBr26ih0rwKJR1jO7w6c8K6EroqqBBcy5U',
    appId: '1:688032127071:ios:983c8406f8446d69c2e3ea',
    messagingSenderId: '688032127071',
    projectId: 'swaminarayanstatus-f8550',
    storageBucket: 'swaminarayanstatus-f8550.appspot.com',
    iosClientId: '688032127071-h70v4cmn466cdtldm2u9ij57q9du78ua.apps.googleusercontent.com',
    iosBundleId: 'com.mobileappxperts.swaminarayanstatus',
  );
}
