import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/get_auth_state_changes_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Stream<bool> get authStateChanges {
    return super.noSuchMethod(
      Invocation.getter(#authStateChanges),
      returnValue: Stream<bool>.empty(),
      returnValueForMissingStub: Stream<bool>.empty(),
    ) as Stream<bool>;
  }
}

void main() {
  late GetAuthStateChangesUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = GetAuthStateChangesUseCase(authRepository: mockAuthRepository);
  });

  test('should get authStateChanges from the repository', () async {
    // Arrange
    final testStream = Stream<bool>.fromIterable([true, false, true]);
    when(mockAuthRepository.authStateChanges).thenAnswer((_) => testStream);

    // Act
    final result = useCase.execute();

    // Assert
    expect(result, emitsInOrder([true, false, true]));
    verify(mockAuthRepository.authStateChanges).called(1);
  });

  test('should propagate errors from the repository', () async {
    // Arrange
    final exception = Exception('Authentication state changes failed');
    when(mockAuthRepository.authStateChanges)
        .thenAnswer((_) => Stream<bool>.error(exception));

    // Act & Assert
    expect(
      useCase.execute(),
      emitsError(exception),
    );
  });
}
