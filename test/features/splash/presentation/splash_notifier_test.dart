import 'package:flutter_firebase_auth_clean_arch/core/di/service_locator.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/splash_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/splash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashNotifier', () {
    late MockAuthRepository mockAuthRepository;
    late SplashNotifier splashNotifier;

    setUp(() {
      mockAuthRepository = MockAuthRepository();

      // Check if the repository is already registered
      if (!serviceLocator.isRegistered<AuthRepository>()) {
        serviceLocator.registerSingleton<AuthRepository>(mockAuthRepository);
      } else {
        // Reset the mock if it's already registered
        serviceLocator
          ..unregister<AuthRepository>()
          ..registerSingleton<AuthRepository>(mockAuthRepository);
      }

      // Create the SplashNotifier
      splashNotifier = SplashNotifier();
    });

    tearDown(() {
      if (serviceLocator.isRegistered<AuthRepository>()) {
        serviceLocator.unregister<AuthRepository>();
      }
    });

    test('initial state is SplashInitial', () {
      expect(splashNotifier.state, isA<SplashInitial>());
    });

    group('initialize', () {
      test('emits SplashLoading then SplashNavigate when authenticated',
          () async {
        // Arrange
        when(mockAuthRepository.isAuthenticated())
            .thenAnswer((_) async => true);

        // Act
        await splashNotifier.initialize();

        // Assert
        expect(splashNotifier.state, isA<SplashNavigate>());
        expect(
          (splashNotifier.state as SplashNavigate).isAuthenticated,
          isTrue,
        );
      });

      test('emits SplashLoading then SplashNavigate when not authenticated',
          () async {
        // Arrange
        when(mockAuthRepository.isAuthenticated())
            .thenAnswer((_) async => false);

        // Act
        await splashNotifier.initialize();

        // Assert
        expect(splashNotifier.state, isA<SplashNavigate>());
        expect(
          (splashNotifier.state as SplashNavigate).isAuthenticated,
          isFalse,
        );
      });

      test('emits SplashError when an exception is thrown', () async {
        // Arrange
        when(mockAuthRepository.isAuthenticated())
            .thenThrow(Exception('Test error'));

        // Act
        await splashNotifier.initialize();

        // Assert
        expect(splashNotifier.state, isA<SplashError>());
        expect(
          (splashNotifier.state as SplashError).message,
          contains('Exception: Test error'),
        );
      });
    });

    group('retry', () {
      test('calls initialize method', () async {
        // Arrange
        when(mockAuthRepository.isAuthenticated())
            .thenAnswer((_) async => true);

        // Act
        await splashNotifier.retry();

        // Assert
        expect(splashNotifier.state, isA<SplashNavigate>());
        expect(
          (splashNotifier.state as SplashNavigate).isAuthenticated,
          isTrue,
        );
        verify(mockAuthRepository.isAuthenticated()).called(1);
      });
    });

    group('splashProvider', () {
      test('creates a SplashNotifier instance', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act
        final notifier = container.read(splashProvider.notifier);

        // Assert
        expect(notifier, isA<SplashNotifier>());
        expect(container.read(splashProvider), isA<SplashInitial>());
      });
    });
  });
}
