import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/state/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_provider_listener_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('registerProvider with listener', () {
    late MockAuthRepository mockAuthRepository;
    late ProviderContainer container;
    late List<RegisterState> stateHistory;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      stateHistory = [];

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      )..listen<RegisterState>(
          registerProvider,
          (_, state) => stateHistory.add(state),
          fireImmediately: true,
        );

      addTearDown(container.dispose);
    });

    test('initial state is RegisterInitial', () {
      expect(stateHistory, [isA<RegisterInitial>()]);
    });

    test(
        '''createUserWithEmailAndPassword emits [RegisterInitial, RegisterLoading, RegisterSuccess] on success''',
        () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      when(
        mockAuthRepository.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).thenAnswer((_) async {});

      // Clear the initial state
      stateHistory.clear();

      // Act
      await container
          .read(registerProvider.notifier)
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

      // Assert
      expect(stateHistory.length, 2);
      expect(stateHistory[0], isA<RegisterLoading>());
      expect(stateHistory[1], isA<RegisterSuccess>());
    });

    test(
        '''createUserWithEmailAndPassword emits [RegisterInitial, RegisterLoading, RegisterError] on failure''',
        () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const errorMessage = 'Email already in use';

      when(
        mockAuthRepository.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).thenThrow(errorMessage);

      // Clear the initial state
      stateHistory.clear();

      // Act
      await container
          .read(registerProvider.notifier)
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

      // Assert
      expect(stateHistory.length, 2);
      expect(stateHistory[0], isA<RegisterLoading>());
      expect(stateHistory[1], isA<RegisterError>());
      expect((stateHistory[1] as RegisterError).message, errorMessage);
    });

    test('reset emits RegisterInitial', () {
      // Arrange - put the provider in an error state
      container.read(registerProvider.notifier).state =
          const RegisterError('Some error');

      // Clear the state history
      stateHistory.clear();

      // Act
      container.read(registerProvider.notifier).reset();

      // Assert
      expect(stateHistory.length, 1);
      expect(stateHistory[0], isA<RegisterInitial>());
    });
  });
}
