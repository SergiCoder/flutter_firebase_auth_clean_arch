import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';

/// Use case for signing out the current user.
///
/// This use case encapsulates the business logic for signing out a user
/// from the application.
class SignOutUseCase {
  /// Creates a new [SignOutUseCase] with the given repository.
  ///
  /// [authRepository] The repository that provides authentication operations.
  const SignOutUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// The authentication repository used to perform the sign-out operation.
  final AuthRepository _authRepository;

  /// Executes the sign-out operation.
  ///
  /// Returns a [Future] that completes when the sign-out operation is finished.
  /// Throws an exception if the sign-out operation fails.
  Future<void> execute() {
    // Here you could add additional business logic like:
    // - Logging
    // - Analytics
    // - Cleanup operations before sign-out

    // For now, we'll simply delegate to the repository
    return _authRepository.signOut();
  }
}
