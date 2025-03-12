import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/error.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';

/// Firebase implementation of the [AuthRepository] interface
class FirebaseAuthRepository implements AuthRepository {
  /// Creates a new [FirebaseAuthRepository] with the given Firebase Auth
  /// instance and error handler
  FirebaseAuthRepository({
    required FirebaseAuth firebaseAuth,
    required ErrorHandler errorHandler,
  })  : _firebaseAuth = firebaseAuth,
        _errorHandler = errorHandler;

  /// The Firebase Auth instance
  final FirebaseAuth _firebaseAuth;

  /// The error handler
  final ErrorHandler _errorHandler;

  @override
  Future<bool> isAuthenticated() async {
    try {
      return _firebaseAuth.currentUser != null;
    } catch (e) {
      throw _errorHandler.handleError(e);
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _errorHandler.handleFirebaseAuthError(e);
    } catch (e) {
      throw _errorHandler.handleError(e);
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
    } on FirebaseAuthException catch (e) {
      throw _errorHandler.handleFirebaseAuthError(e);
    } catch (e) {
      throw _errorHandler.handleError(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw _errorHandler.handleError(e);
    }
  }

  @override
  Stream<bool> get authStateChanges {
    try {
      return _firebaseAuth.authStateChanges().map((user) => user != null);
    } catch (e) {
      throw _errorHandler.handleError(e);
    }
  }
}
