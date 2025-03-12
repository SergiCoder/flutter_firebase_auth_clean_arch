import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';

/// Use case for checking if a user is currently authenticated.
///
/// This use case encapsulates the business logic for determining whether
/// a user is currently signed in to the application.
class IsAuthenticatedUseCase {
  /// Creates a new [IsAuthenticatedUseCase] with the given repository.
  ///
  /// [authRepository] The repository that provides authentication operations.
  const IsAuthenticatedUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// The authentication repository used to check authentication status.
  final AuthRepository _authRepository;

  /// Executes the authentication check operation.
  ///
  /// Returns a [Future<bool>] that completes with true if the user is
  /// authenticated, or false otherwise.
  Future<bool> execute() {
    // Here you could add additional business logic like:
    // - Checking token validity
    // - Verifying session expiration
    // - Logging
    // - Analytics

    // For now, we'll simply delegate to the repository
    return _authRepository.isAuthenticated();
  }
}
