import 'package:equatable/equatable.dart';

/// Represents the different states of the register screen
abstract class RegisterState extends Equatable {
  /// Creates a new [RegisterState]
  const RegisterState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the register screen
class RegisterInitial extends RegisterState {
  /// Creates a new [RegisterInitial] state
  const RegisterInitial();
}

/// The loading state of the register screen
class RegisterLoading extends RegisterState {
  /// Creates a new [RegisterLoading] state
  const RegisterLoading();
}

/// The success state of the register screen
class RegisterSuccess extends RegisterState {
  /// Creates a new [RegisterSuccess] state
  const RegisterSuccess();
}

/// The error state of the register screen
class RegisterError extends RegisterState {
  /// Creates a new [RegisterError] state with the given error message
  const RegisterError(this.message);

  /// The error message
  final String message;

  @override
  List<Object?> get props => [message];
}
