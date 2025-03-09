import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_firebase_auth_clean_arch/core/auth/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/core/di/service_locator.dart';
import 'package:flutter_firebase_auth_clean_arch/core/firebase/firebase_options.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/locale_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_router.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_notifier_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_router_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
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

  // Initialize dependency injection after Firebase is initialized
  await initServiceLocator();

  runApp(const MyApp());
}

/// The main application widget
class MyApp extends StatefulWidget {
  /// Creates a new [MyApp] widget
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LocaleProvider _localeProvider;
  late final AuthRouterNotifier _authNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _localeProvider = serviceLocator<LocaleProvider>();
    _authNotifier = serviceLocator<AuthRouterNotifier>();
    _router = AppRouter.createRouter(
      authNotifier: _authNotifier,
    );
  }

  @override
  void dispose() {
    _authNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthRepositoryProvider(
      repository: serviceLocator<AuthRepository>(),
      child: AuthNotifierProvider(
        notifier: _authNotifier,
        child: AnimatedBuilder(
          animation: _localeProvider,
          builder: (context, child) {
            return MaterialApp.router(
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              // Localization setup
              localizationsDelegates: AppLocalization.localizationDelegates,
              supportedLocales: AppLocalization.supportedLocales,
              locale: _localeProvider.locale,
              // Router configuration
              routerConfig: _router,
            );
          },
        ),
      ),
    );
  }
}
