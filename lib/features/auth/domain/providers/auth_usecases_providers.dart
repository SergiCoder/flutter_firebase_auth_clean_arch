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
