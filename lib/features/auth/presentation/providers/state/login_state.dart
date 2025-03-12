import 'package:equatable/equatable.dart';

/// Represents the different states of the login screen
abstract class LoginState extends Equatable {
  /// Creates a new [LoginState]
  const LoginState();

  @override
  List<Object?> get props => [];
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
  List<Object?> get props => [message];
}
