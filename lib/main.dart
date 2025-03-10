import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_firebase_auth_clean_arch/core/di/service_locator.dart';
import 'package:flutter_firebase_auth_clean_arch/core/firebase/firebase_options.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/locale_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_router.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_router_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Use URL path strategy to remove "#" from URLs (web only)
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }

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

  // Initialize dependency injection after Firebase is initialized
  await initServiceLocator();

  // Initialize required services
  final localeProvider = serviceLocator<LocaleProvider>();

  runApp(
    ProviderScope(
      child: MyApp(
        localeProvider: localeProvider,
      ),
    ),
  );
}

/// The main application widget
class MyApp extends ConsumerWidget {
  /// Creates a new [MyApp] widget
  const MyApp({
    required this.localeProvider,
    super.key,
  });

  /// The locale provider for handling app localization
  final LocaleProvider localeProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the auth router notifier from the provider
    final authNotifier = ref.watch(authRouterNotifierProvider);

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
