import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';

/// Use case for signing in a user with email and password.
///
/// This use case encapsulates the business logic for authenticating a user
/// with their email and password credentials.
class SignInWithEmailAndPasswordUseCase {
  /// Creates a new [SignInWithEmailAndPasswordUseCase] with the given
  /// repository.
  ///
  /// [authRepository] The repository that provides authentication operations.
  const SignInWithEmailAndPasswordUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// The authentication repository used to perform the sign-in operation.
  final AuthRepository _authRepository;

  /// Executes the sign-in operation with the provided credentials.
  ///
  /// [email] The user's email address.
  /// [password] The user's password.
  ///
  /// Returns a [Future] that completes when the sign-in operation is finished.
  /// Throws an exception if the sign-in operation fails.
  Future<void> execute(String email, String password) {
    // Here you could add additional business logic like:
    // - Input validation
    // - Logging
    // - Analytics
    // - Rate limiting

    // For now, we'll simply delegate to the repository
    return _authRepository.signInWithEmailAndPassword(email, password);
  }
}
