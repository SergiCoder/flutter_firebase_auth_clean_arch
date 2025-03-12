import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/core/url_strategy/default_url_strategy.dart'
    if (dart.library.html) 'package:flutter_firebase_auth_clean_arch/core/url_strategy/web_url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Use URL path strategy to remove "#" from URLs (web only)
  usePathUrlStrategy();

  // Load environment variables
  await dotenv.load();

  // Initialize Firebase with proper configuration
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Firebase App Check with debug token
    // Skip App Check for web platform as it can cause issues
    if (!kIsWeb) {
      await FirebaseAppCheck.instance.activate();
    }
  } catch (e) {
    // Log the error but continue with the app
    log('Firebase initialization error: $e');
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// The main application widget
class MyApp extends HookConsumerWidget {
  /// Creates a new [MyApp] widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the auth router notifier from the provider
    final authNotifier = ref.watch(authRouterNotifierProvider);

    // Get the locale provider from the provider
    final localeProvider = ref.watch(localeProviderProvider);

    // Create the router with the auth notifier
    final router = AppRouter.createRouter(
      authNotifier: authNotifier,
    );

    return MaterialApp.router(
      theme: AppTheme.theme,
      // Localization setup
      localizationsDelegates: AppLocalization.localizationDelegates,
      supportedLocales: AppLocalization.supportedLocales,
      locale: localeProvider.locale,
      // Router configuration
      routerConfig: router,
    );
  }
}
