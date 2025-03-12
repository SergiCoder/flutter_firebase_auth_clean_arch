import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Mock FirebaseAuth instance for testing
FirebaseAuth? _mockFirebaseAuth;

/// Set a mock FirebaseAuth instance for testing
/// This should only be used in tests
void setMockFirebaseAuth(FirebaseAuth mock) {
  _mockFirebaseAuth = mock;
}

/// Reset the mock FirebaseAuth instance
/// This should be called after tests
void resetMockFirebaseAuth() {
  _mockFirebaseAuth = null;
}

/// Function to get the Firebase Auth instance
/// This can be overridden in tests
FirebaseAuth getFirebaseAuth() => _mockFirebaseAuth ?? FirebaseAuth.instance;

/// Provider for Firebase Authentication
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => getFirebaseAuth(),
);

/// Provider for the Firebase implementation of the authentication repository
final firebaseAuthRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    errorHandler: ref.watch(errorHandlerProvider),
  ),
);
