import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<bool> isAuthenticated() {
    return super.noSuchMethod(
      Invocation.method(#isAuthenticated, []),
      returnValue: Future<bool>.value(false),
      returnValueForMissingStub: Future<bool>.value(false),
    ) as Future<bool>;
  }
}

void main() {
  late IsAuthenticatedUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = IsAuthenticatedUseCase(authRepository: mockAuthRepository);
  });

  test('should call isAuthenticated on the repository', () async {
    // Arrange
    when(mockAuthRepository.isAuthenticated()).thenAnswer((_) async => true);

    // Act
    final result = await useCase.execute();

    // Assert
    verify(mockAuthRepository.isAuthenticated()).called(1);
    expect(result, isTrue);
  });

  test('should return false when user is not authenticated', () async {
    // Arrange
    when(mockAuthRepository.isAuthenticated()).thenAnswer((_) async => false);

    // Act
    final result = await useCase.execute();

    // Assert
    expect(result, isFalse);
  });

  test('should propagate exceptions from the repository', () async {
    // Arrange
    final exception = Exception('Authentication check failed');
    when(mockAuthRepository.isAuthenticated()).thenThrow(exception);

    // Act & Assert
    expect(
      () => useCase.execute(),
      throwsA(exception),
    );
  });
}
