import 'package:flutter_firebase_auth_clean_arch/core/di/service_locator.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A notifier that manages the state of the register screen
class RegisterNotifier extends StateNotifier<RegisterState> {
  /// Creates a new [RegisterNotifier]
  RegisterNotifier() : super(const RegisterInitial());

  /// The authentication repository
  final _authRepository = serviceLocator<AuthRepository>();

  /// Attempts to create a new user with the provided email and password
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const RegisterLoading();

    try {
      await _authRepository.createUserWithEmailAndPassword(email, password);
      state = const RegisterSuccess();
    } catch (e) {
      state = RegisterError(e.toString());
    }
  }

  /// Resets the register state to initial
  void reset() {
    state = const RegisterInitial();
  }
}

/// Provider for the register screen state
final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(),
);
