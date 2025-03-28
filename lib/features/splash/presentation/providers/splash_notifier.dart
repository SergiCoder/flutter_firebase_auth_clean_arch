import 'dart:async';
import 'dart:developer' as developer;

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

      // Log successful initialization
      developer.log(
        'Splash screen initialized, authentication status: $isAuthenticated',
        name: 'SplashNotifier',
      );
    } catch (e) {
      // If an unknown error occurs, update the state to error
      state = SplashError(e.toString());

      // Log initialization error
      developer.log(
        'Splash screen initialization failed',
        name: 'SplashNotifier',
        error: e,
      );
    }
  }

  /// Retries the initialization process
  Future<void> retry() async {
    // Log retry attempt
    developer.log(
      'Retrying splash screen initialization',
      name: 'SplashNotifier',
    );

    await initialize();
  }

  /// Resets the splash state to initial
  void reset() {
    state = const SplashInitial();

    // Log state reset
    developer.log(
      'Splash state reset',
      name: 'SplashNotifier',
    );
  }
}

/// Provider for the splash screen state
final splashProvider =
    StateNotifierProvider.autoDispose<SplashNotifier, SplashState>(
  (ref) => SplashNotifier(
    isAuthenticatedUseCase: ref.watch(isAuthenticatedUseCaseProvider),
  ),
);
