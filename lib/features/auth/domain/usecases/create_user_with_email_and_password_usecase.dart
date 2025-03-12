import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';

/// Use case for creating a new user with email and password.
///
/// This use case encapsulates the business logic for registering a new user
/// with their email and password credentials.
class CreateUserWithEmailAndPasswordUseCase {
  /// Creates a new [CreateUserWithEmailAndPasswordUseCase] with the given
  /// repository.
  ///
  /// [authRepository] The repository that provides authentication operations.
  const CreateUserWithEmailAndPasswordUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// The authentication repository used to perform the user creation operation.
  final AuthRepository _authRepository;

  /// Executes the user creation operation with the provided credentials.
  ///
  /// [email] The user's email address.
  /// [password] The user's password.
  ///
  /// Returns a [Future] that completes when the registration operation is
  /// finished. Throws an exception if the registration operation fails.
  Future<void> execute(String email, String password) {
    // Here you could add additional business logic like:
    // - Input validation
    // - Password strength checking
    // - Logging
    // - Analytics
    // - Rate limiting

    // For now, we'll simply delegate to the repository
    return _authRepository.createUserWithEmailAndPassword(email, password);
  }
}
