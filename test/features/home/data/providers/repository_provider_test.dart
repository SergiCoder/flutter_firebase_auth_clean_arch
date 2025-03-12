import 'package:flutter_firebase_auth_clean_arch/features/home/data/providers/providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/data/repositories/in_memory_home_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('Home Repository Provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('homeRepositoryImplProvider should create an InMemoryHomeRepository',
        () {
      // Act
      final repository = container.read(homeRepositoryImplProvider);

      // Assert
      expect(repository, isA<InMemoryHomeRepository>());
    });
  });
}
