import 'dart:developer' as developer;

import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A notifier that manages the state of the register screen
class RegisterNotifier extends StateNotifier<RegisterState> {
  /// Creates a new [RegisterNotifier] with the provided use case
  ///
  /// [createUserUseCase] The use case for creating a user with email and
  /// password
  RegisterNotifier({
    required CreateUserWithEmailAndPasswordUseCase createUserUseCase,
  })  : _createUserUseCase = createUserUseCase,
        super(const RegisterInitial());

  /// The use case for creating a user with email and password
  final CreateUserWithEmailAndPasswordUseCase _createUserUseCase;

  /// Attempts to create a new user with the provided email and password
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const RegisterLoading();

    try {
      await _createUserUseCase.execute(email, password);
      state = const RegisterSuccess();

      // Log successful registration
      developer.log(
        'Registration successful',
        name: 'RegisterNotifier',
      );
    } on InvalidCredentialsException catch (e) {
      // Handle invalid credentials specifically
      state = RegisterError(e.message);

      // Log the error
      developer.log(
        'Registration failed: Invalid credentials - ${e.message}',
        name: 'RegisterNotifier',
        error: e,
      );
    } on EmailAlreadyInUseException catch (e) {
      // Handle email already in use specifically
      state = RegisterError(e.message);

      // Log the error
      developer.log(
        'Registration failed: Email already in use - ${e.message}',
        name: 'RegisterNotifier',
        error: e,
      );
    } on WeakPasswordException catch (e) {
      // Handle weak password specifically
      state = RegisterError(e.message);

      // Log the error
      developer.log(
        'Registration failed: Weak password - ${e.message}',
        name: 'RegisterNotifier',
        error: e,
      );
    } on AuthException catch (e) {
      // Handle other auth exceptions
      state = RegisterError(e.message);

      // Log the error
      developer.log(
        'Registration failed: Auth error - ${e.message}',
        name: 'RegisterNotifier',
        error: e,
      );
    } on AppException catch (e) {
      // Handle general app exceptions
      state = RegisterError(e.message);

      // Log the error
      developer.log(
        'Registration failed: App error - ${e.message}',
        name: 'RegisterNotifier',
        error: e,
      );
    } catch (e) {
      // Handle unexpected errors
      state = RegisterError(e.toString());

      // Log the error
      developer.log(
        'Registration failed: Unexpected error',
        name: 'RegisterNotifier',
        error: e,
      );
    }
  }

  /// Resets the register state to initial
  void reset() {
    state = const RegisterInitial();
  }
}

/// Provider for the register screen state
final registerProvider =
    StateNotifierProvider.autoDispose<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(
    createUserUseCase: ref.watch(createUserWithEmailAndPasswordUseCaseProvider),
  ),
);
