import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<void> signOut() async {
    return super.noSuchMethod(
      Invocation.method(#signOut, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

void main() {
  late SignOutUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignOutUseCase(authRepository: mockAuthRepository);
  });

  test('should call signOut on the repository', () async {
    // Act
    await useCase.execute();

    // Assert
    verify(mockAuthRepository.signOut()).called(1);
  });

  test('should propagate exceptions from the repository', () async {
    // Arrange
    final exception = Exception('Sign out failed');
    when(mockAuthRepository.signOut()).thenThrow(exception);

    // Act & Assert
    expect(
      () => useCase.execute(),
      throwsA(exception),
    );
  });
}
