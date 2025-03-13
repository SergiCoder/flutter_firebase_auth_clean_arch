import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/usecases.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the auth repository.
/// This is a placeholder that should be overridden in the composition root.
/// This approach maintains clean architecture by ensuring the domain layer
/// doesn't depend on the data layer.
final authRepositoryDomainProvider = Provider<AuthRepository>(
  (ref) => throw UnimplementedError(
    'authRepositoryDomainProvider has not been overridden. '
    'Make sure to override this provider in the composition root.',
  ),
);

/// Provider for the sign in with email and password use case.
///
/// This provider creates and exposes a [SignInWithEmailAndPasswordUseCase]
/// instance that can be used throughout the application.
final signInWithEmailAndPasswordUseCaseProvider =
    Provider<SignInWithEmailAndPasswordUseCase>(
  (ref) => SignInWithEmailAndPasswordUseCase(
    authRepository: ref.watch(authRepositoryDomainProvider),
  ),
);

/// Provider for the create user with email and password use case.
///
/// This provider creates and exposes a [CreateUserWithEmailAndPasswordUseCase]
/// instance that can be used throughout the application.
final createUserWithEmailAndPasswordUseCaseProvider =
    Provider<CreateUserWithEmailAndPasswordUseCase>(
  (ref) => CreateUserWithEmailAndPasswordUseCase(
    authRepository: ref.watch(authRepositoryDomainProvider),
  ),
);

/// Provider for the sign out use case.
///
/// This provider creates and exposes a [SignOutUseCase]
/// instance that can be used throughout the application.
final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(
    authRepository: ref.watch(authRepositoryDomainProvider),
  ),
);

/// Provider for the is authenticated use case.
///
/// This provider creates and exposes an [IsAuthenticatedUseCase]
/// instance that can be used throughout the application.
final isAuthenticatedUseCaseProvider = Provider<IsAuthenticatedUseCase>(
  (ref) => IsAuthenticatedUseCase(
    authRepository: ref.watch(authRepositoryDomainProvider),
  ),
);

/// Provider for the get authentication state changes use case.
///
/// This provider creates and exposes a [GetAuthStateChangesUseCase]
/// instance that can be used throughout the application.
final getAuthStateChangesUseCaseProvider = Provider<GetAuthStateChangesUseCase>(
  (ref) => GetAuthStateChangesUseCase(
    authRepository: ref.watch(authRepositoryDomainProvider),
  ),
);
