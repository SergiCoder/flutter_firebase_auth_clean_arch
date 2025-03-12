import 'package:flutter_firebase_auth_clean_arch/core/di/providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/providers.dart'
    as auth_data;
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart'
    as auth_domain;
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/data/providers/providers.dart'
    as home_data;
import 'package:flutter_firebase_auth_clean_arch/features/home/data/repositories/in_memory_home_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/domain/providers/home_usecases_providers.dart'
    as home_domain;
import 'package:flutter_firebase_auth_clean_arch/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/data/providers/providers.dart'
    as splash_data;
import 'package:flutter_firebase_auth_clean_arch/features/splash/data/repositories/in_memory_splash_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/providers/splash_usecases_providers.dart'
    as splash_domain;
import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/repositories/splash_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

// Mock repositories
class MockAuthRepository extends Mock implements AuthRepository {}

class MockHomeRepository extends Mock implements HomeRepository {}

class MockSplashRepository extends Mock implements SplashRepository {}

// Mock implementations
class MockFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}

class MockInMemoryHomeRepository extends Mock
    implements InMemoryHomeRepository {}

class MockInMemorySplashRepository extends Mock
    implements InMemorySplashRepository {}

void main() {
  group('Core DI Providers', () {
    test('overrides list should contain the correct number of overrides', () {
      // Assert
      expect(overrides.length, equals(3));
    });

    test('domain providers should throw when not overridden', () {
      // Create a container without the overrides
      final containerWithoutOverrides = ProviderContainer();

      try {
        // Auth repository
        expect(
          () => containerWithoutOverrides
              .read(auth_domain.authRepositoryProvider),
          throwsA(isA<UnimplementedError>()),
        );

        // Home repository
        expect(
          () => containerWithoutOverrides
              .read(home_domain.homeRepositoryProvider),
          throwsA(isA<UnimplementedError>()),
        );

        // Splash repository
        expect(
          () => containerWithoutOverrides
              .read(splash_domain.splashRepositoryProvider),
          throwsA(isA<UnimplementedError>()),
        );
      } finally {
        // Clean up
        containerWithoutOverrides.dispose();
      }
    });

    test('overrides should connect domain repositories to data implementations',
        () {
      // Create a container with mock implementations
      final container = ProviderContainer(
        overrides: [
          // Override the implementation providers with fake values
          // We're not testing the implementations themselves, just the wiring
          auth_data.authRepositoryImplProvider.overrideWithValue(
            FakeAuthRepository(),
          ),
          home_data.homeRepositoryImplProvider.overrideWithValue(
            FakeHomeRepository(),
          ),
          splash_data.splashRepositoryImplProvider.overrideWithValue(
            FakeSplashRepository(),
          ),
          // Add the core DI overrides
          ...overrides,
        ],
      );

      try {
        // Verify that the domain providers return the implementations
        // from the data layer

        // Auth repository
        final authRepo = container.read(auth_domain.authRepositoryProvider);
        expect(authRepo, isA<FakeAuthRepository>());

        // Home repository
        final homeRepo = container.read(home_domain.homeRepositoryProvider);
        expect(homeRepo, isA<FakeHomeRepository>());

        // Splash repository
        final splashRepo =
            container.read(splash_domain.splashRepositoryProvider);
        expect(splashRepo, isA<FakeSplashRepository>());
      } finally {
        // Clean up
        container.dispose();
      }
    });
  });
}

// Simple fake implementations for testing the wiring
class FakeAuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeHomeRepository implements HomeRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeSplashRepository implements SplashRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
