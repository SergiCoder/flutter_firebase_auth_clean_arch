import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';

/// Firebase implementation of the [AuthRepository] interface
class FirebaseAuthRepository implements AuthRepository {
  /// Creates a new [FirebaseAuthRepository] with the given Firebase Auth
  /// instance
  FirebaseAuthRepository({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  /// The Firebase Auth instance
  final FirebaseAuth _firebaseAuth;

  @override
  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Special handling for web platform
      if (kIsWeb) {
        // On web, just use a generic error message to avoid any type checking
        throw Exception(
          'Authentication failed. Please check your credentials.',
        );
      } else {
        // On mobile, we can include more details
        throw Exception('Authentication failed: $e');
      }
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Special handling for web platform
      if (kIsWeb) {
        // On web, just use a generic error message to avoid any type checking
        throw Exception('Registration failed. Please try again.');
      } else {
        // On mobile, we can include more details
        throw Exception('Registration failed: $e');
      }
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Sign out failed. Please try again.');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Special handling for web platform
      if (kIsWeb) {
        // On web, just use a generic error message to avoid any type checking
        throw Exception('Password reset failed. Please try again.');
      } else {
        // On mobile, we can include more details
        throw Exception('Password reset failed: $e');
      }
    }
  }

  @override
  Stream<bool> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((user) => user != null);
}
