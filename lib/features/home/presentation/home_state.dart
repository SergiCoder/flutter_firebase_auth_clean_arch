/// Base state class for the home screen
abstract class HomeState {
  /// Creates a new [HomeState]
  const HomeState();
}

/// Initial state of the home screen
class HomeInitial extends HomeState {
  /// Creates a new [HomeInitial] state
  const HomeInitial();
}

/// Loading state of the home screen
class HomeLoading extends HomeState {
  /// Creates a new [HomeLoading] state
  const HomeLoading();
}

/// Loaded state of the home screen with user email
class HomeLoaded extends HomeState {
  /// Creates a new [HomeLoaded] state with the given email
  const HomeLoaded({required this.email});

  /// The email of the authenticated user
  final String email;
}

/// Error state of the home screen
class HomeError extends HomeState {
  /// Creates a new [HomeError] state with the given error message
  const HomeError(this.message);

  /// The error message
  final String message;
}
