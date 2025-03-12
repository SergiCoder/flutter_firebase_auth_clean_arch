import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting authentication state changes.
///
/// This use case encapsulates the business logic for observing changes
/// in the user's authentication state.
class GetAuthStateChangesUseCase {
  /// Creates a new [GetAuthStateChangesUseCase] with the given repository.
  ///
  /// [authRepository] The repository that provides authentication operations.
  const GetAuthStateChangesUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// The authentication repository used to get authentication state changes.
  final AuthRepository _authRepository;

  /// Executes the get authentication state changes operation.
  ///
  /// Returns a [Stream<bool>] that emits true when the user is authenticated,
  /// and false otherwise.
  Stream<bool> execute() {
    // Here you could add additional business logic like:
    // - Filtering or transforming the stream
    // - Logging
    // - Analytics
    // - Caching

    // For now, we'll simply delegate to the repository
    return _authRepository.authStateChanges;
  }
}
