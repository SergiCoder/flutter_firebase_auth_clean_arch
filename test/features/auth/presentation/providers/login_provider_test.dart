import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

class MockSignInWithEmailAndPasswordUseCase extends Mock
    implements SignInWithEmailAndPasswordUseCase {
  @override
  Future<void> execute(String email, String password) async {
    return super.noSuchMethod(
      Invocation.method(#execute, [email, password]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

void main() {
  group('loginProvider', () {
    late MockSignInWithEmailAndPasswordUseCase mockSignInUseCase;
    late ProviderContainer container;

    setUp(() {
      mockSignInUseCase = MockSignInWithEmailAndPasswordUseCase();

      container = ProviderContainer(
        overrides: [
          signInWithEmailAndPasswordUseCaseProvider.overrideWithValue(
            mockSignInUseCase,
          ),
        ],
      );

      addTearDown(container.dispose);
    });

    test('creates a LoginNotifier with the correct initial state', () {
      final loginState = container.read(loginProvider);

      expect(loginState, isA<LoginInitial>());
    });

    test('signInWithEmailAndPassword updates state correctly on success',
        () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      await container.read(loginProvider.notifier).signInWithEmailAndPassword(
            email: email,
            password: password,
          );

      // Assert
      verify(
        mockSignInUseCase.execute(
          email,
          password,
        ),
      ).called(1);

      expect(container.read(loginProvider), isA<LoginSuccess>());
    });

    test('signInWithEmailAndPassword updates state correctly on failure',
        () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const errorMessage = 'Authentication failed';

      when(
        mockSignInUseCase.execute(
          email,
          password,
        ),
      ).thenThrow(errorMessage);

      // Act
      await container.read(loginProvider.notifier).signInWithEmailAndPassword(
            email: email,
            password: password,
          );

      // Assert
      verify(
        mockSignInUseCase.execute(
          email,
          password,
        ),
      ).called(1);

      final state = container.read(loginProvider);
      expect(state, isA<LoginError>());
      expect((state as LoginError).message, errorMessage);
    });

    test('reset changes state to LoginInitial', () {
      // Arrange - put the provider in an error state
      container.read(loginProvider.notifier).state =
          const LoginError('Some error');

      // Act
      container.read(loginProvider.notifier).reset();

      // Assert
      expect(container.read(loginProvider), isA<LoginInitial>());
    });
  });
}
