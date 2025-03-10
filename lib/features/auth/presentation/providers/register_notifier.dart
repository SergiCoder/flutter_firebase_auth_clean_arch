import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A notifier that manages the state of the register screen
class RegisterNotifier extends StateNotifier<RegisterState> {
  /// Creates a new [RegisterNotifier] with the provided [authRepository]
  RegisterNotifier({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const RegisterInitial());

  /// The authentication repository
  final AuthRepository _authRepository;

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
final registerProvider =
    StateNotifierProvider.autoDispose<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);
