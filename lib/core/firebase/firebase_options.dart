import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// This class provides platform-specific Firebase configuration options loaded
/// from environment variables defined in your .env file. It automatically
/// selects the appropriate configuration based on the current platform at
/// runtime.
///
/// Before using this class, ensure:
/// 1. You have created a .env file with the required Firebase configuration
///    variables
/// 2. You have loaded the environment variables using dotenv.load() before
///    initializing Firebase
/// 3. Your .env file is added to .gitignore to prevent exposing sensitive
///    credentials
///
/// Required environment variables in .env file:
/// - FIREBASE_API_KEY: Your Firebase API key
/// - FIREBASE_PROJECT_ID: Your Firebase project ID
/// - FIREBASE_MESSAGING_SENDER_ID: Your Firebase messaging sender ID
/// - FIREBASE_APP_ID: Your Firebase app ID
/// - FIREBASE_AUTH_DOMAIN: Your Firebase auth domain (for web)
/// - FIREBASE_STORAGE_BUCKET: Your Firebase storage bucket
/// - FIREBASE_MEASUREMENT_ID: Your Firebase measurement ID (for web)
///
/// Platform-specific variables (optional, falls back to general variables):
/// - FIREBASE_ANDROID_API_KEY: Android-specific API key
/// - FIREBASE_ANDROID_APP_ID: Android-specific app ID
/// - FIREBASE_IOS_API_KEY: iOS-specific API key
/// - FIREBASE_IOS_APP_ID: iOS-specific app ID
/// - FIREBASE_IOS_BUNDLE_ID: iOS bundle identifier
///
/// Example usage:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await dotenv.load(); // Load environment variables first
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  /// Returns the appropriate [FirebaseOptions] configuration for the current
  /// platform.
  ///
  /// This getter automatically detects the current platform at runtime and
  /// returns the corresponding Firebase configuration. It handles web, Android,
  /// iOS, macOS, and Windows platforms, throwing an [UnsupportedError] for
  /// Linux or other unsupported platforms.
  ///
  /// The configuration values are loaded from environment variables defined in
  /// your .env file, which must be loaded before accessing this getter.
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
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for fuchsia platform.',
        );
    }
  }

  /// Firebase configuration for Web platform.
  ///
  /// Loads configuration from the following environment variables:
  /// - FIREBASE_API_KEY
  /// - FIREBASE_APP_ID
  /// - FIREBASE_MESSAGING_SENDER_ID
  /// - FIREBASE_PROJECT_ID
  /// - FIREBASE_AUTH_DOMAIN
  /// - FIREBASE_STORAGE_BUCKET
  /// - FIREBASE_MEASUREMENT_ID
  static FirebaseOptions get web => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
        measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '',
      );

  /// Firebase configuration for Android platform.
  ///
  /// Loads configuration from the following environment variables:
  /// - FIREBASE_ANDROID_API_KEY (falls back to FIREBASE_API_KEY)
  /// - FIREBASE_ANDROID_APP_ID (falls back to FIREBASE_APP_ID)
  /// - FIREBASE_MESSAGING_SENDER_ID
  /// - FIREBASE_PROJECT_ID
  /// - FIREBASE_STORAGE_BUCKET
  static FirebaseOptions get android => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_ANDROID_API_KEY'] ??
            dotenv.env['FIREBASE_API_KEY'] ??
            '',
        appId: dotenv.env['FIREBASE_ANDROID_APP_ID'] ??
            dotenv.env['FIREBASE_APP_ID'] ??
            '',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
      );

  /// Firebase configuration for iOS platform.
  ///
  /// Loads configuration from the following environment variables:
  /// - FIREBASE_IOS_API_KEY (falls back to FIREBASE_API_KEY)
  /// - FIREBASE_IOS_APP_ID (falls back to FIREBASE_APP_ID)
  /// - FIREBASE_MESSAGING_SENDER_ID
  /// - FIREBASE_PROJECT_ID
  /// - FIREBASE_STORAGE_BUCKET
  /// - FIREBASE_IOS_BUNDLE_ID
  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_IOS_API_KEY'] ??
            dotenv.env['FIREBASE_API_KEY'] ??
            '',
        appId: dotenv.env['FIREBASE_IOS_APP_ID'] ??
            dotenv.env['FIREBASE_APP_ID'] ??
            '',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
        iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? '',
      );

  /// Firebase configuration for macOS platform.
  ///
  /// Loads configuration from the following environment variables:
  /// - FIREBASE_IOS_API_KEY (falls back to FIREBASE_API_KEY)
  /// - FIREBASE_IOS_APP_ID (falls back to FIREBASE_APP_ID)
  /// - FIREBASE_MESSAGING_SENDER_ID
  /// - FIREBASE_PROJECT_ID
  /// - FIREBASE_STORAGE_BUCKET
  /// - FIREBASE_IOS_BUNDLE_ID
  static FirebaseOptions get macos => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_IOS_API_KEY'] ??
            dotenv.env['FIREBASE_API_KEY'] ??
            '',
        appId: dotenv.env['FIREBASE_IOS_APP_ID'] ??
            dotenv.env['FIREBASE_APP_ID'] ??
            '',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
        iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? '',
      );

  /// Firebase configuration for Windows platform.
  ///
  /// Loads configuration from the following environment variables:
  /// - FIREBASE_API_KEY
  /// - FIREBASE_APP_ID
  /// - FIREBASE_MESSAGING_SENDER_ID
  /// - FIREBASE_PROJECT_ID
  /// - FIREBASE_AUTH_DOMAIN
  /// - FIREBASE_STORAGE_BUCKET
  /// - FIREBASE_MEASUREMENT_ID
  static FirebaseOptions get windows => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
        measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '',
      );
}
