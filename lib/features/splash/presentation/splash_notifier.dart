import 'dart:async';

import 'package:flutter_firebase_auth_clean_arch/core/di/service_locator.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/splash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A notifier that manages the state of the splash screen
class SplashNotifier extends StateNotifier<SplashState> {
  /// Creates a new [SplashNotifier]
  SplashNotifier() : super(const SplashInitial());

  /// The authentication repository
  final _authRepository = serviceLocator<AuthRepository>();

  /// Initializes the splash screen
  Future<void> initialize() async {
    state = const SplashLoading();

    try {
      // Simulate a 3-second loading time
      await Future<void>.delayed(const Duration(seconds: 3));

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
  (ref) => SplashNotifier(),
);
