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
  group('loginProvider with listener', () {
    late MockSignInWithEmailAndPasswordUseCase mockSignInUseCase;
    late ProviderContainer container;
    late List<LoginState> stateHistory;

    setUp(() {
      mockSignInUseCase = MockSignInWithEmailAndPasswordUseCase();
      stateHistory = [];

      container = ProviderContainer(
        overrides: [
          signInWithEmailAndPasswordUseCaseProvider.overrideWithValue(
            mockSignInUseCase,
          ),
        ],
      )..listen<LoginState>(
          loginProvider,
          (_, state) => stateHistory.add(state),
          fireImmediately: true,
        );

      addTearDown(container.dispose);
    });

    test('initial state is LoginInitial', () {
      expect(stateHistory, [isA<LoginInitial>()]);
    });

    test(
        '''signInWithEmailAndPassword emits [LoginInitial, LoginLoading, LoginSuccess] on success''',
        () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Clear the initial state
      stateHistory.clear();

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

      expect(stateHistory.length, 2);
      expect(stateHistory[0], isA<LoginLoading>());
      expect(stateHistory[1], isA<LoginSuccess>());
    });

    test(
        '''signInWithEmailAndPassword emits [LoginInitial, LoginLoading, LoginError] on failure''',
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

      // Clear the initial state
      stateHistory.clear();

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

      expect(stateHistory.length, 2);
      expect(stateHistory[0], isA<LoginLoading>());
      expect(stateHistory[1], isA<LoginError>());
      expect((stateHistory[1] as LoginError).message, errorMessage);
    });

    test('reset emits LoginInitial', () {
      // Arrange - put the provider in an error state
      container.read(loginProvider.notifier).state =
          const LoginError('Some error');

      // Clear the state history
      stateHistory.clear();

      // Act
      container.read(loginProvider.notifier).reset();

      // Assert
      expect(stateHistory.length, 1);
      expect(stateHistory[0], isA<LoginInitial>());
    });
  });
}
