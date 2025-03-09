import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/locale_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_router_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

/// Global service locator instance
final serviceLocator = GetIt.instance;

/// Initializes the service locator with all dependencies
Future<void> initServiceLocator() async {
  // External services
  serviceLocator
    ..registerLazySingleton<FirebaseAuth>(
      () => FirebaseAuth.instance,
    )

    // Repositories
    ..registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(
        firebaseAuth: serviceLocator<FirebaseAuth>(),
      ),
    )

    // Providers
    ..registerLazySingleton<LocaleProvider>(LocaleProvider.new)

    // Notifiers
    ..registerLazySingleton<AuthRouterNotifier>(
      () => AuthRouterNotifier(
        authRepository: serviceLocator<AuthRepository>(),
      ),
    );
}
