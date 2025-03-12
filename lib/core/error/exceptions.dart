/// Base exception class for all app-specific exceptions
abstract class AppException implements Exception {
  /// Creates a new [AppException] with the given message, code, and original
  /// error
  ///
  /// [message] A user-friendly error message
  /// [code] An optional error code for identifying the error type
  /// [originalError] The original error that caused this exception
  const AppException(
    this.message, {
    this.code,
    this.originalError,
  });

  /// A user-friendly error message
  final String message;

  /// An optional error code for identifying the error type
  final String? code;

  /// The original error that caused this exception
  final dynamic originalError;

  @override
  String toString() => 'AppException: $code - $message';
}

/// Authentication-related exceptions
class AuthException extends AppException {
  /// Creates a new [AuthException] with the given message, code, and original
  /// error
  const AuthException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception thrown when user credentials are invalid
class InvalidCredentialsException extends AuthException {
  /// Creates a new [InvalidCredentialsException] with an optional message and
  /// original error
  const InvalidCredentialsException({
    String message = 'Invalid email or password',
    dynamic originalError,
  }) : super(
          message,
          code: 'invalid_credentials',
          originalError: originalError,
        );
}

/// Exception thrown when a user account already exists
class EmailAlreadyInUseException extends AuthException {
  /// Creates a new [EmailAlreadyInUseException] with an optional message and
  /// original error
  const EmailAlreadyInUseException({
    String message = 'This email is already in use',
    dynamic originalError,
  }) : super(
          message,
          code: 'email_already_in_use',
          originalError: originalError,
        );
}

/// Exception thrown when a user is not authenticated
class UserNotAuthenticatedException extends AuthException {
  /// Creates a new [UserNotAuthenticatedException] with an optional message and
  /// original error
  const UserNotAuthenticatedException({
    String message = 'User is not authenticated',
    dynamic originalError,
  }) : super(
          message,
          code: 'user_not_authenticated',
          originalError: originalError,
        );
}

/// Exception thrown when a weak password is provided
class WeakPasswordException extends AuthException {
  /// Creates a new [WeakPasswordException] with an optional message and
  /// original error
  const WeakPasswordException({
    String message = 'The password provided is too weak',
    dynamic originalError,
  }) : super(
          message,
          code: 'weak_password',
          originalError: originalError,
        );
}

/// Data-related exceptions
class DataException extends AppException {
  /// Creates a new [DataException] with the given message, code, and original
  /// error
  const DataException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception thrown when data is not found
class NotFoundException extends DataException {
  /// Creates a new [NotFoundException] with an optional message and original
  /// error
  const NotFoundException({
    String message = 'The requested data was not found',
    dynamic originalError,
  }) : super(
          message,
          code: 'not_found',
          originalError: originalError,
        );
}

/// Exception thrown when there's a permission issue
class PermissionDeniedException extends DataException {
  /// Creates a new [PermissionDeniedException] with an optional message and
  /// original error
  const PermissionDeniedException({
    String message = 'Permission denied',
    dynamic originalError,
  }) : super(
          message,
          code: 'permission_denied',
          originalError: originalError,
        );
}

/// Network-related exceptions
class NetworkException extends AppException {
  /// Creates a new [NetworkException] with the given message, code, and
  /// original error
  const NetworkException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception thrown when there's no internet connection
class NoInternetException extends NetworkException {
  /// Creates a new [NoInternetException] with an optional message and original
  /// error
  const NoInternetException({
    String message = 'No internet connection',
    dynamic originalError,
  }) : super(
          message,
          code: 'no_internet',
          originalError: originalError,
        );
}

/// Exception thrown when a timeout occurs
class TimeoutException extends NetworkException {
  /// Creates a new [TimeoutException] with an optional message and original
  /// error
  const TimeoutException({
    String message = 'The operation timed out',
    dynamic originalError,
  }) : super(
          message,
          code: 'timeout',
          originalError: originalError,
        );
}

/// Unexpected exceptions
class UnexpectedException extends AppException {
  /// Creates a new [UnexpectedException] with an optional message and original
  /// error
  const UnexpectedException({
    String message = 'An unexpected error occurred',
    dynamic originalError,
  }) : super(
          message,
          code: 'unexpected_error',
          originalError: originalError,
        );
}
