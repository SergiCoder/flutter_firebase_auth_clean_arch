import 'dart:async';

import 'package:flutter_firebase_auth_clean_arch/features/features.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A notifier that manages the state of the splash screen
class SplashNotifier extends StateNotifier<SplashState> {
  /// Creates a new [SplashNotifier] with the provided [authRepository]
  SplashNotifier({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const SplashInitial());

  /// The authentication repository
  final AuthRepository _authRepository;

  /// Initializes the splash screen
  Future<void> initialize() async {
    state = const SplashLoading();

    try {
      // Check if the user is already authenticated
      final isAuthenticated = await _authRepository.isAuthenticated();

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
    authRepository: ref.watch(authRepositoryProvider),
  ),
);
