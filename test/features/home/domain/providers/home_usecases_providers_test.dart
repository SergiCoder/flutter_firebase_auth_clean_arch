import 'package:flutter_firebase_auth_clean_arch/features/home/domain/providers/home_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/domain/usecases/some_home_operation_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_usecases_providers_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late ProviderContainer container;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
  });

  group('homeRepositoryProvider', () {
    test('throws UnimplementedError when not overridden', () {
      // Arrange
      container = ProviderContainer();

      // Act & Assert
      expect(
        () => container.read(homeRepositoryProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('returns the overridden repository when overridden', () {
      // Arrange
      container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(mockHomeRepository),
        ],
      );

      // Act
      final result = container.read(homeRepositoryProvider);

      // Assert
      expect(result, equals(mockHomeRepository));
    });
  });

  group('someHomeOperationUseCaseProvider', () {
    test('creates SomeHomeOperationUseCase with the repository from provider',
        () {
      // Arrange
      container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(mockHomeRepository),
        ],
      );

      // Act
      final useCase = container.read(someHomeOperationUseCaseProvider);

      // Assert
      expect(useCase, isA<SomeHomeOperationUseCase>());

      // Verify the use case works with the provided repository
      when(mockHomeRepository.someHomeOperation())
          .thenAnswer((_) async => Future<void>.value());

      // Call the use case to verify it uses the mock repository
      useCase.execute();

      // Verify the repository method was called
      verify(mockHomeRepository.someHomeOperation()).called(1);
    });
  });
}
