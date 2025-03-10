import 'package:flutter_firebase_auth_clean_arch/core/di/service_locator.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ProviderContainer container;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();

    // Override the service locator to return our mock
    serviceLocator.registerSingleton<AuthRepository>(mockAuthRepository);

    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
    serviceLocator.reset();
  });

  group('AuthRepositoryProvider', () {
    test('provides the auth repository from service locator', () {
      // Act
      final repository = container.read(authRepositoryProvider);

      // Assert
      expect(repository, equals(mockAuthRepository));
    });

    test('provides the same instance each time', () {
      // Act
      final repository1 = container.read(authRepositoryProvider);
      final repository2 = container.read(authRepositoryProvider);

      // Assert
      expect(identical(repository1, repository2), isTrue);
    });
  });
}
