import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ProviderContainer container;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryDomainProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Auth Use Cases Providers', () {
    test(
        '''signInWithEmailAndPasswordUseCaseProvider provides the correct use case''',
        () {
      // Act
      final useCase = container.read(signInWithEmailAndPasswordUseCaseProvider);

      // Assert
      expect(useCase, isA<SignInWithEmailAndPasswordUseCase>());
    });

    test(
        '''createUserWithEmailAndPasswordUseCaseProvider provides the correct use case''',
        () {
      // Act
      final useCase =
          container.read(createUserWithEmailAndPasswordUseCaseProvider);

      // Assert
      expect(useCase, isA<CreateUserWithEmailAndPasswordUseCase>());
    });

    test('signOutUseCaseProvider provides the correct use case', () {
      // Act
      final useCase = container.read(signOutUseCaseProvider);

      // Assert
      expect(useCase, isA<SignOutUseCase>());
    });

    test('isAuthenticatedUseCaseProvider provides the correct use case', () {
      // Act
      final useCase = container.read(isAuthenticatedUseCaseProvider);

      // Assert
      expect(useCase, isA<IsAuthenticatedUseCase>());
    });

    test('getAuthStateChangesUseCaseProvider provides the correct use case',
        () {
      // Act
      final useCase = container.read(getAuthStateChangesUseCaseProvider);

      // Assert
      expect(useCase, isA<GetAuthStateChangesUseCase>());
    });

    test('providers create new instances', () {
      // Act
      final signInUseCase =
          container.read(signInWithEmailAndPasswordUseCaseProvider);
      final createUserUseCase =
          container.read(createUserWithEmailAndPasswordUseCaseProvider);
      final signOutUseCase = container.read(signOutUseCaseProvider);
      final isAuthenticatedUseCase =
          container.read(isAuthenticatedUseCaseProvider);
      final getAuthStateChangesUseCase =
          container.read(getAuthStateChangesUseCaseProvider);

      // Assert - Each use case should be a different instance
      expect(identical(signInUseCase, createUserUseCase), isFalse);
      expect(identical(signInUseCase, signOutUseCase), isFalse);
      expect(identical(signInUseCase, isAuthenticatedUseCase), isFalse);
      expect(identical(signInUseCase, getAuthStateChangesUseCase), isFalse);
    });
  });
}
