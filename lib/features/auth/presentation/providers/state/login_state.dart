import 'package:flutter/foundation.dart';

/// Represents the different states of the login screen
@immutable
abstract class LoginState {
  /// Creates a new [LoginState]
  const LoginState();
}

/// The initial state of the login screen
class LoginInitial extends LoginState {
  /// Creates a new [LoginInitial] state
  const LoginInitial();
}

/// The loading state of the login screen
class LoginLoading extends LoginState {
  /// Creates a new [LoginLoading] state
  const LoginLoading();
}

/// The success state of the login screen
class LoginSuccess extends LoginState {
  /// Creates a new [LoginSuccess] state
  const LoginSuccess();
}

/// The error state of the login screen
class LoginError extends LoginState {
  /// Creates a new [LoginError] state with the given error message
  const LoginError(this.message);

  /// The error message
  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
