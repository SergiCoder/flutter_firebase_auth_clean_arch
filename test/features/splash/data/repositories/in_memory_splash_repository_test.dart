import 'package:flutter_firebase_auth_clean_arch/features/splash/data/repositories/in_memory_splash_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InMemorySplashRepository', () {
    late InMemorySplashRepository repository;

    setUp(() {
      repository = const InMemorySplashRepository();
    });

    test('someSplashOperation completes successfully', () async {
      // Act & Assert
      // Since this is a placeholder implementation, we just verify it completes
      await expectLater(repository.someSplashOperation(), completes);
    });

    test('constructor creates a constant instance', () {
      // Arrange
      const repository1 = InMemorySplashRepository();
      const repository2 = InMemorySplashRepository();

      // Assert
      // Verify that const constructor creates identical instances
      expect(identical(repository1, repository2), isTrue);
    });
  });
}
