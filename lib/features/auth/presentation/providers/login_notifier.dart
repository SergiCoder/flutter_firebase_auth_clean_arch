import 'package:flutter_firebase_auth_clean_arch/core/di/service_locator.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A notifier that manages the state of the login screen
class LoginNotifier extends StateNotifier<LoginState> {
  /// Creates a new [LoginNotifier]
  LoginNotifier() : super(const LoginInitial());

  /// The authentication repository
  final _authRepository = serviceLocator<AuthRepository>();

  /// Attempts to sign in a user with the provided email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const LoginLoading();

    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      state = const LoginSuccess();
    } catch (e) {
      state = LoginError(e.toString());
    }
  }

  /// Resets the login state to initial
  void reset() {
    state = const LoginInitial();
  }
}

/// Provider for the login screen state
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(),
);
