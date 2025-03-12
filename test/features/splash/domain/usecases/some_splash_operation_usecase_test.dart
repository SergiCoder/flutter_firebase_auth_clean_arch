import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/repositories/splash_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/usecases/some_splash_operation_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
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
  group('SomeSplashOperationUseCase', () {
    late MockSplashRepository mockSplashRepository;
    late SomeSplashOperationUseCase useCase;

    setUp(() {
      mockSplashRepository = MockSplashRepository();
      useCase = SomeSplashOperationUseCase(
        splashRepository: mockSplashRepository,
      );
    });

    test('should call someSplashOperation on the repository', () async {
      // Arrange
      when(mockSplashRepository.someSplashOperation()).thenAnswer((_) async {});

      // Act
      await useCase.execute();

      // Assert
      verify(mockSplashRepository.someSplashOperation()).called(1);
    });

    test('should propagate exceptions from the repository', () async {
      // Arrange
      final exception = Exception('Test exception');
      when(mockSplashRepository.someSplashOperation()).thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(equals(exception)),
      );
    });
  });
}
