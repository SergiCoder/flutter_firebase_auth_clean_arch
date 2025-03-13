import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/providers/splash_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/repositories/splash_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/usecases/some_splash_operation_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

class MockSplashRepository extends Mock implements SplashRepository {
  @override
  Future<void> someSplashOperation() {
    return super.noSuchMethod(
      Invocation.method(#someSplashOperation, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    ) as Future<void>;
  }
}

void main() {
  group('Splash UseCases Providers', () {
    late ProviderContainer container;
    late MockSplashRepository mockSplashRepository;

    setUp(() {
      mockSplashRepository = MockSplashRepository();
      container = ProviderContainer(
        overrides: [
          splashRepositoryDomainProvider
              .overrideWithValue(mockSplashRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
        '''splashRepositoryDomainProvider throws UnimplementedError when not overridden''',
        () {
      // Create a container without overrides
      final emptyContainer = ProviderContainer();

      // Assert
      expect(
        () => emptyContainer.read(splashRepositoryDomainProvider),
        throwsA(isA<UnimplementedError>()),
      );

      // Clean up
      emptyContainer.dispose();
    });

    test(
        'someSplashOperationUseCaseProvider creates SomeSplashOperationUseCase',
        () {
      // Act
      final useCase = container.read(someSplashOperationUseCaseProvider);

      // Assert
      expect(useCase, isA<SomeSplashOperationUseCase>());
    });

    test(
        '''someSplashOperationUseCaseProvider uses the repository from splashRepositoryProvider''',
        () async {
      // Arrange
      when(mockSplashRepository.someSplashOperation()).thenAnswer((_) async {});

      // Act
      final useCase = container.read(someSplashOperationUseCaseProvider);
      await useCase.execute();

      // Assert
      verify(mockSplashRepository.someSplashOperation()).called(1);
    });
  });
}
