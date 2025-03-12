import 'dart:developer' as developer;

import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
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
  /// Throws an [AppException] if the sign-in operation fails.
  Future<void> execute(String email, String password) async {
    // Input validation
    if (email.isEmpty) {
      throw const InvalidCredentialsException(
        message: 'Email cannot be empty',
      );
    }

    if (password.isEmpty) {
      throw const InvalidCredentialsException(
        message: 'Password cannot be empty',
      );
    }

    if (!_isValidEmail(email)) {
      throw const InvalidCredentialsException(
        message: 'Please enter a valid email address',
      );
    }

    try {
      // Log the sign-in attempt (without sensitive data)
      developer.log(
        'Sign-in attempt with email: ${_maskEmail(email)}',
        name: 'SignInUseCase',
      );

      // Delegate to the repository
      await _authRepository.signInWithEmailAndPassword(email, password);

      // Log successful sign-in
      developer.log(
        'Sign-in successful for email: ${_maskEmail(email)}',
        name: 'SignInUseCase',
      );
    } on AppException catch (e) {
      // Log the error
      developer.log(
        'Sign-in failed for email: ${_maskEmail(email)} - ${e.message}',
        name: 'SignInUseCase',
        error: e,
      );
      // Rethrow the domain exception
      rethrow;
    } catch (e) {
      // Log unexpected errors
      developer.log(
        'Unexpected error during sign-in for email: ${_maskEmail(email)}',
        name: 'SignInUseCase',
        error: e,
      );
      // Propagate the original exception instead of wrapping it
      rethrow;
    }
  }

  /// Validates if the email is in a valid format
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }

  /// Masks an email address for logging purposes
  String _maskEmail(String email) {
    if (email.isEmpty || !email.contains('@')) {
      return '***';
    }

    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return '***@$domain';
    }

    return '${username.substring(0, 2)}***@$domain';
  }
}
