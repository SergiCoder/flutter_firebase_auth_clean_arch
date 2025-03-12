import 'package:equatable/equatable.dart';

/// Base class for all error states
abstract class ErrorState extends Equatable {
  /// Creates a new [ErrorState]
  const ErrorState();

  @override
  List<Object?> get props => [];
}

/// Initial state for error handling
class ErrorInitial extends ErrorState {
  /// Creates a new [ErrorInitial] state
  const ErrorInitial();
}

/// State when an error is being processed
class ErrorProcessing extends ErrorState {
  /// Creates a new [ErrorProcessing] state
  const ErrorProcessing();
}

/// State when an error has been handled successfully
class ErrorHandled extends ErrorState {
  /// Creates a new [ErrorHandled] state
  const ErrorHandled();
}

/// State when an error has occurred during error handling
class ErrorFailed extends ErrorState {
  /// Creates a new [ErrorFailed] state with the given error message
  ///
  /// [message] The error message
  const ErrorFailed(this.message);

  /// The error message
  final String message;

  @override
  List<Object?> get props => [message];
}
