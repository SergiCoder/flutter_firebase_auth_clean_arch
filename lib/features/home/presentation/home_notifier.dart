import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/core/di/service_locator.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A notifier that manages the state of the home screen
class HomeNotifier extends StateNotifier<HomeState> {
  /// Creates a new [HomeNotifier]
  HomeNotifier() : super(const HomeInitial());

  /// The authentication repository
  final _authRepository = serviceLocator<AuthRepository>();

  /// The Firebase Auth instance
  final _firebaseAuth = FirebaseAuth.instance;

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
      await _authRepository.signOut();
    } catch (e) {
      // Even if sign out fails, we'll still navigate away
      // but we could handle this differently if needed
    }
  }
}

/// Provider for the home screen state
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);
