import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/state/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_provider_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('registerProvider', () {
    late MockAuthRepository mockAuthRepository;
    late ProviderContainer container;

    setUp(() {
      mockAuthRepository = MockAuthRepository();

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );

      addTearDown(container.dispose);
    });

    test('creates a RegisterNotifier with the correct initial state', () {
      final registerState = container.read(registerProvider);

      expect(registerState, isA<RegisterInitial>());
    });

    test('createUserWithEmailAndPassword updates state correctly on success',
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

      // Act
      await container
          .read(registerProvider.notifier)
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

      // Assert
      verify(
        mockAuthRepository.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);

      expect(container.read(registerProvider), isA<RegisterSuccess>());
    });

    test('createUserWithEmailAndPassword updates state correctly on failure',
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

      // Act
      await container
          .read(registerProvider.notifier)
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

      // Assert
      verify(
        mockAuthRepository.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);

      final state = container.read(registerProvider);
      expect(state, isA<RegisterError>());
      expect((state as RegisterError).message, errorMessage);
    });

    test('reset changes state to RegisterInitial', () {
      // Arrange - put the provider in an error state
      container.read(registerProvider.notifier).state =
          const RegisterError('Some error');

      // Act
      container.read(registerProvider.notifier).reset();

      // Assert
      expect(container.read(registerProvider), isA<RegisterInitial>());
    });
  });
}
