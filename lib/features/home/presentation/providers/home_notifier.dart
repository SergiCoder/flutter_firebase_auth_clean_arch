import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/features/features.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A notifier that manages the state of the home screen
class HomeNotifier extends StateNotifier<HomeState> {
  /// Creates a new [HomeNotifier]
  ///
  /// Requires [firebaseAuth] for authentication operations and [signOutUseCase]
  /// for sign out functionality
  HomeNotifier({
    required FirebaseAuth firebaseAuth,
    required SignOutUseCase signOutUseCase,
  })  : _firebaseAuth = firebaseAuth,
        _signOutUseCase = signOutUseCase,
        super(const HomeInitial());

  /// The sign out use case
  final SignOutUseCase _signOutUseCase;

  /// The Firebase Auth instance
  final FirebaseAuth _firebaseAuth;

  /// Initializes the home screen
  Future<void> initialize() async {
    state = const HomeLoading();

    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        state = HomeLoaded(email: currentUser.email ?? 'User');

        // Log successful initialization
        developer.log(
          'Home screen initialized for user: ${currentUser.email ?? 'User'}',
          name: 'HomeNotifier',
        );
      } else {
        // Use a specific state for unauthenticated users instead of an error
        state = const HomeUnauthenticated();

        // Log unauthenticated state
        developer.log(
          'Home initialization: User is not authenticated',
          name: 'HomeNotifier',
        );
      }
    } catch (e) {
      state = HomeError(e.toString());

      // Log initialization error
      developer.log(
        'Home initialization failed',
        name: 'HomeNotifier',
        error: e,
      );
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _signOutUseCase.execute();

      // Log successful sign out
      developer.log(
        'User signed out successfully',
        name: 'HomeNotifier',
      );
    } catch (e) {
      // Even if sign out fails, we'll still navigate away
      // but we could handle this differently if needed

      // Log sign out error
      developer.log(
        'Sign out failed',
        name: 'HomeNotifier',
        error: e,
      );
    }
  }

  /// Resets the home state to initial
  void reset() {
    state = const HomeInitial();

    // Log state reset
    developer.log(
      'Home state reset',
      name: 'HomeNotifier',
    );
  }
}

/// Provider for the home screen state
final homeProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    signOutUseCase: ref.watch(signOutUseCaseProvider),
  ),
);
