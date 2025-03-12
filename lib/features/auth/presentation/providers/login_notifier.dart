import 'dart:developer' as developer;

import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A notifier that manages the state of the login screen
class LoginNotifier extends StateNotifier<LoginState> {
  /// Creates a new [LoginNotifier] with the provided use case
  ///
  /// [signInUseCase] The use case for signing in with email and password
  LoginNotifier({required SignInWithEmailAndPasswordUseCase signInUseCase})
      : _signInUseCase = signInUseCase,
        super(const LoginInitial());

  /// The use case for signing in with email and password
  final SignInWithEmailAndPasswordUseCase _signInUseCase;

  /// Attempts to sign in a user with the provided email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const LoginLoading();

    try {
      await _signInUseCase.execute(email, password);
      state = const LoginSuccess();

      // Log successful login
      developer.log(
        'Login successful',
        name: 'LoginNotifier',
      );
    } on InvalidCredentialsException catch (e) {
      // Handle invalid credentials specifically
      state = LoginError(e.message);

      // Log the error
      developer.log(
        'Login failed: Invalid credentials - ${e.message}',
        name: 'LoginNotifier',
        error: e,
      );
    } on AuthException catch (e) {
      // Handle other auth exceptions
      state = LoginError(e.message);

      // Log the error
      developer.log(
        'Login failed: Auth error - ${e.message}',
        name: 'LoginNotifier',
        error: e,
      );
    } on AppException catch (e) {
      // Handle general app exceptions
      state = LoginError(e.message);

      // Log the error
      developer.log(
        'Login failed: App error - ${e.message}',
        name: 'LoginNotifier',
        error: e,
      );
    } catch (e) {
      // Handle unexpected errors
      state = LoginError(e.toString());

      // Log the error
      developer.log(
        'Login failed: Unexpected error',
        name: 'LoginNotifier',
        error: e,
      );
    }
  }

  /// Resets the login state to initial
  void reset() {
    state = const LoginInitial();
  }
}

/// Provider for the login screen state
final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(
    signInUseCase: ref.watch(signInWithEmailAndPasswordUseCaseProvider),
  ),
);
