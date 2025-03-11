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
  group('loginProvider', () {
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

    test('creates a LoginNotifier with the correct initial state', () {
      final loginState = container.read(loginProvider);

      expect(loginState, isA<LoginInitial>());
    });

    test('signInWithEmailAndPassword updates state correctly on success',
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

      // Act
      await container.read(loginProvider.notifier).signInWithEmailAndPassword(
            email: email,
            password: password,
          );

      // Assert
      verify(
        mockAuthRepository.signInWithEmailAndPassword(
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
        mockAuthRepository.signInWithEmailAndPassword(
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
        mockAuthRepository.signInWithEmailAndPassword(
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
