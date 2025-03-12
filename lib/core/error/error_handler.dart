import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';

/// A centralized error handler for the application
class ErrorHandler {
  /// Creates a new [ErrorHandler]
  const ErrorHandler();

  /// Maps Firebase Auth errors to domain exceptions
  AppException handleFirebaseAuthError(FirebaseAuthException error) {
    developer.log(
      'Firebase Auth Error: ${error.code} - ${error.message}',
      name: 'ErrorHandler',
      error: error,
    );

    switch (error.code) {
      case 'invalid-email':
      case 'user-not-found':
      case 'wrong-password':
      case 'user-disabled':
        return InvalidCredentialsException(
          message: error.message ?? 'Invalid email or password',
          originalError: error,
        );
      case 'email-already-in-use':
        return EmailAlreadyInUseException(
          message: error.message ?? 'This email is already in use',
          originalError: error,
        );
      case 'weak-password':
        return WeakPasswordException(
          message: error.message ?? 'The password provided is too weak',
          originalError: error,
        );
      case 'operation-not-allowed':
        return AuthException(
          'This operation is not allowed',
          code: 'operation_not_allowed',
          originalError: error,
        );
      case 'requires-recent-login':
        return AuthException(
          'Please log in again to continue',
          code: 'requires_recent_login',
          originalError: error,
        );
      default:
        return AuthException(
          error.message ?? 'An authentication error occurred',
          code: error.code,
          originalError: error,
        );
    }
  }

  /// Maps Firebase errors to domain exceptions
  AppException handleFirebaseError(FirebaseException error) {
    developer.log(
      'Firebase Error: ${error.code} - ${error.message}',
      name: 'ErrorHandler',
      error: error,
    );

    switch (error.code) {
      case 'permission-denied':
        return PermissionDeniedException(
          message: error.message ?? 'Permission denied',
          originalError: error,
        );
      case 'not-found':
        return NotFoundException(
          message: error.message ?? 'The requested data was not found',
          originalError: error,
        );
      default:
        return DataException(
          error.message ?? 'A database error occurred',
          code: error.code,
          originalError: error,
        );
    }
  }

  /// Handles general errors and maps them to domain exceptions
  AppException handleError(dynamic error) {
    developer.log(
      'Unexpected Error: $error',
      name: 'ErrorHandler',
      error: error,
    );

    if (error is FirebaseAuthException) {
      return handleFirebaseAuthError(error);
    } else if (error is FirebaseException) {
      return handleFirebaseError(error);
    } else if (error is AppException) {
      // If it's already a domain exception, just return it
      return error;
    } else {
      // For any other type of error, wrap it in an UnexpectedException
      return UnexpectedException(
        message: error?.toString() ?? 'An unexpected error occurred',
        originalError: error,
      );
    }
  }
}
