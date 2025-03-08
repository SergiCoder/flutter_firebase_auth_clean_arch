/// Custom exceptions for the application
///
/// This file contains all custom exceptions used throughout the application
/// to handle specific error cases in a type-safe way.
library;

/// Base exception class for all application exceptions
abstract class AppException implements Exception {
  /// Creates a new [AppException] with the given [message]
  const AppException(this.message);

  /// The error message associated with this exception
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when there is no internet connection
class NetworkException extends AppException {
  /// Creates a new [NetworkException] with an optional custom [message]
  const NetworkException([super.message = 'No internet connection available']);
}

/// Exception thrown when authentication fails due to incorrect credentials
class AuthenticationException extends AppException {
  /// Creates a new [AuthenticationException] with an optional custom [message]
  const AuthenticationException([
    super.message = 'Incorrect email or password',
  ]);
}
