import 'dart:async';

import 'package:flutter_firebase_auth_clean_arch/features/features.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A notifier that manages the state of the splash screen
class SplashNotifier extends StateNotifier<SplashState> {
  /// Creates a new [SplashNotifier] with the provided use case
  ///
  /// [isAuthenticatedUseCase] The use case for checking if a user is
  /// authenticated
  SplashNotifier({required IsAuthenticatedUseCase isAuthenticatedUseCase})
      : _isAuthenticatedUseCase = isAuthenticatedUseCase,
        super(const SplashInitial());

  /// The use case for checking if a user is authenticated
  final IsAuthenticatedUseCase _isAuthenticatedUseCase;

  /// Initializes the splash screen
  Future<void> initialize() async {
    state = const SplashLoading();

    try {
      // Check if the user is already authenticated
      final isAuthenticated = await _isAuthenticatedUseCase.execute();

      // After loading, navigate to the next screen with authentication info
      state = SplashNavigate(isAuthenticated: isAuthenticated);
    } catch (e) {
      // If an unknown error occurs, update the state to error
      state = SplashError(e.toString());
    }
  }

  /// Retries the initialization process
  Future<void> retry() async {
    await initialize();
  }
}

/// Provider for the splash screen state
final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>(
  (ref) => SplashNotifier(
    isAuthenticatedUseCase: ref.watch(isAuthenticatedUseCaseProvider),
  ),
);
