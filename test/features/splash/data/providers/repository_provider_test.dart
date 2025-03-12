import 'package:flutter_firebase_auth_clean_arch/features/splash/data/providers/repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/data/repositories/in_memory_splash_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('Splash Repository Provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('splashRepositoryImplProvider provides InMemorySplashRepository', () {
      // Act
      final repository = container.read(splashRepositoryImplProvider);

      // Assert
      expect(repository, isA<InMemorySplashRepository>());
    });

    test('splashRepositoryImplProvider provides a constant instance', () {
      // Act
      final repository1 = container.read(splashRepositoryImplProvider);
      final repository2 = container.read(splashRepositoryImplProvider);

      // Assert
      // Verify that the provider returns the same instance each time
      expect(identical(repository1, repository2), isTrue);
    });
  });
}
