/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Returns whether the user is currently authenticated
  Future<bool> isAuthenticated();

  /// Signs in a user with email and password
  Future<void> signInWithEmailAndPassword(String email, String password);

  /// Creates a new user with email and password
  Future<void> createUserWithEmailAndPassword(String email, String password);

  /// Signs out the current user
  Future<void> signOut();

  /// Sends a password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Stream of authentication state changes
  Stream<bool> get authStateChanges;
}
