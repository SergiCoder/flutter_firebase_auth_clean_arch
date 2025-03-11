import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_provider_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('loginProvider with listener', () {
    late MockAuthRepository mockAuthRepository;
    late ProviderContainer container;
    late List<LoginState> stateHistory;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      stateHistory = [];

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
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

      when(
        mockAuthRepository.signInWithEmailAndPassword(
          email,
          password,
        ),
      ).thenAnswer((_) async {});

      // Clear the initial state
      stateHistory.clear();

      // Act
      await container.read(loginProvider.notifier).signInWithEmailAndPassword(
            email: email,
            password: password,
          );

      // Assert
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
        mockAuthRepository.signInWithEmailAndPassword(
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
