// File generated from your Firebase project config.
// Project: mylocality-37277

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ── Web ─────────────────────────────────────────────────────────────────
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDFH7UHfrKAmcOVQG4pF-h38nulKsfVX8I',
    appId: '1:243180288941:web:50d8f1e2430f14fff4ff24',
    messagingSenderId: '243180288941',
    projectId: 'mylocality-37277',
    authDomain: 'mylocality-37277.firebaseapp.com',
    databaseURL: 'https://mylocality-37277-default-rtdb.firebaseio.com',
    storageBucket: 'mylocality-37277.firebasestorage.app',
    measurementId: 'G-7LGSL9T58D',
  );

  // ── Android ─────────────────────────────────────────────────────────────
  // Replace the appId below with the value from your google-services.json
  // ( look for "mobilesdk_app_id" under the android client entry ).
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFH7UHfrKAmcOVQG4pF-h38nulKsfVX8I',
    appId: '1:243180288941:android:REPLACE_WITH_ANDROID_APP_ID',
    messagingSenderId: '243180288941',
    projectId: 'mylocality-37277',
    databaseURL: 'https://mylocality-37277-default-rtdb.firebaseio.com',
    storageBucket: 'mylocality-37277.firebasestorage.app',
  );

  // ── iOS ─────────────────────────────────────────────────────────────────
  // Replace the appId and iosClientId with values from your GoogleService-Info.plist.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFH7UHfrKAmcOVQG4pF-h38nulKsfVX8I',
    appId: '1:243180288941:ios:REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: '243180288941',
    projectId: 'mylocality-37277',
    databaseURL: 'https://mylocality-37277-default-rtdb.firebaseio.com',
    storageBucket: 'mylocality-37277.firebasestorage.app',
    iosClientId: 'REPLACE_WITH_IOS_CLIENT_ID',
    iosBundleId: 'com.example.mylocality',
  );

  // ── macOS ────────────────────────────────────────────────────────────────
  // Same values as iOS — replace appId and iosClientId from GoogleService-Info.plist.
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFH7UHfrKAmcOVQG4pF-h38nulKsfVX8I',
    appId: '1:243180288941:ios:REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: '243180288941',
    projectId: 'mylocality-37277',
    databaseURL: 'https://mylocality-37277-default-rtdb.firebaseio.com',
    storageBucket: 'mylocality-37277.firebasestorage.app',
    iosClientId: 'REPLACE_WITH_IOS_CLIENT_ID',
    iosBundleId: 'com.example.mylocality',
  );
}
