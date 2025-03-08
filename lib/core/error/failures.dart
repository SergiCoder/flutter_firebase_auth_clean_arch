/// Domain-level failures for the application
///
/// In Clean Architecture, failures are used in the domain layer to represent
/// errors that can occur during use case execution. They are translated from
/// exceptions thrown in the data layer.
library;

/// Base failure class for all application failures
abstract class Failure {
  /// Creates a new [Failure] with the given [message]
  const Failure(this.message);

  /// The error message associated with this failure
  final String message;

  @override
  String toString() => message;
}

/// Failure that occurs when there is no internet connection
class NetworkFailure extends Failure {
  /// Creates a new [NetworkFailure] with an optional custom [message]
  const NetworkFailure([super.message = 'No internet connection available']);
}

/// Failure that occurs when authentication fails due to incorrect credentials
class AuthenticationFailure extends Failure {
  /// Creates a new [AuthenticationFailure] with an optional custom [message]
  const AuthenticationFailure([super.message = 'Incorrect email or password']);
}
