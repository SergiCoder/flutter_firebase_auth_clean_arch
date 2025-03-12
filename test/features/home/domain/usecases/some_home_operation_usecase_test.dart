import 'package:flutter_firebase_auth_clean_arch/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/domain/usecases/some_home_operation_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'some_home_operation_usecase_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockHomeRepository;
  late SomeHomeOperationUseCase useCase;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = SomeHomeOperationUseCase(homeRepository: mockHomeRepository);
  });

  group('SomeHomeOperationUseCase', () {
    test('should call someHomeOperation on the repository', () async {
      // Arrange
      when(mockHomeRepository.someHomeOperation())
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await useCase.execute();

      // Assert
      verify(mockHomeRepository.someHomeOperation()).called(1);
    });

    test('should propagate exceptions from the repository', () async {
      // Arrange
      final exception = Exception('Test exception');
      when(mockHomeRepository.someHomeOperation()).thenThrow(exception);

      // Act & Assert
      expect(() => useCase.execute(), throwsA(equals(exception)));
    });
  });
}
