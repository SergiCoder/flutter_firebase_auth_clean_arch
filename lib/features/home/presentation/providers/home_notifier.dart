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
      } else {
        state = const HomeError('No authenticated user found');
      }
    } catch (e) {
      state = HomeError(e.toString());
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _signOutUseCase.execute();
    } catch (e) {
      // Even if sign out fails, we'll still navigate away
      // but we could handle this differently if needed
    }
  }
}

/// Provider for the home screen state
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    signOutUseCase: ref.watch(signOutUseCaseProvider),
  ),
);
