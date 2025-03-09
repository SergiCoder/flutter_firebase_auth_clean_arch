import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:go_router/go_router.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  // Initialize Firebase with proper configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase App Check with debug token
  await FirebaseAppCheck.instance.activate();

  // Initialize dependency injection after Firebase is initialized
  await initServiceLocator();

  // Initialize required services
  final localeProvider = serviceLocator<LocaleProvider>();
  final authNotifier = serviceLocator<AuthRouterNotifier>();
  final router = AppRouter.createRouter(
    authNotifier: authNotifier,
  );

  runApp(
    ProviderScope(
      child: MyApp(
        localeProvider: localeProvider,
        router: router,
      ),
    ),
  );
}

/// The main application widget
class MyApp extends StatelessWidget {
  /// Creates a new [MyApp] widget
  const MyApp({
    required this.localeProvider,
    required this.router,
    super.key,
  });

  /// The locale provider for handling app localization
  final LocaleProvider localeProvider;

  /// The router for app navigation
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
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
