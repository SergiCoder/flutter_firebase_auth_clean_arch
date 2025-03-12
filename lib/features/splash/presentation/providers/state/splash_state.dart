import 'package:equatable/equatable.dart';

/// Represents the different states of the splash screen
abstract class SplashState extends Equatable {
  /// Creates a new [SplashState]
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the splash screen
class SplashInitial extends SplashState {
  /// Creates a new [SplashInitial] state
  const SplashInitial();
}

/// The loading state of the splash screen
class SplashLoading extends SplashState {
  /// Creates a new [SplashLoading] state
  const SplashLoading();
}

/// The error state of the splash screen
class SplashError extends SplashState {
  /// Creates a new [SplashError] state with the given error message
  const SplashError(this.message);

  /// The error message
  final String message;

  @override
  List<Object?> get props => [message];
}

/// The navigate state of the splash screen
class SplashNavigate extends SplashState {
  /// Creates a new [SplashNavigate] state
  ///
  /// The [isAuthenticated] parameter indicates whether the user is already
  /// authenticated
  const SplashNavigate({required this.isAuthenticated});

  /// Whether the user is already authenticated
  final bool isAuthenticated;

  @override
  List<Object?> get props => [isAuthenticated];
}
