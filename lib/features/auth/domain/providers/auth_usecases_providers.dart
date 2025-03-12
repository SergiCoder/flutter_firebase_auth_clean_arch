import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/usecases.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the sign in with email and password use case.
///
/// This provider creates and exposes a [SignInWithEmailAndPasswordUseCase]
/// instance that can be used throughout the application.
final signInWithEmailAndPasswordUseCaseProvider =
    Provider<SignInWithEmailAndPasswordUseCase>(
  (ref) => SignInWithEmailAndPasswordUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

/// Provider for the create user with email and password use case.
///
/// This provider creates and exposes a [CreateUserWithEmailAndPasswordUseCase]
/// instance that can be used throughout the application.
final createUserWithEmailAndPasswordUseCaseProvider =
    Provider<CreateUserWithEmailAndPasswordUseCase>(
  (ref) => CreateUserWithEmailAndPasswordUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

/// Provider for the sign out use case.
///
/// This provider creates and exposes a [SignOutUseCase]
/// instance that can be used throughout the application.
final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

/// Provider for the is authenticated use case.
///
/// This provider creates and exposes an [IsAuthenticatedUseCase]
/// instance that can be used throughout the application.
final isAuthenticatedUseCaseProvider = Provider<IsAuthenticatedUseCase>(
  (ref) => IsAuthenticatedUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

/// Provider for the get authentication state changes use case.
///
/// This provider creates and exposes a [GetAuthStateChangesUseCase]
/// instance that can be used throughout the application.
final getAuthStateChangesUseCaseProvider = Provider<GetAuthStateChangesUseCase>(
  (ref) => GetAuthStateChangesUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);
