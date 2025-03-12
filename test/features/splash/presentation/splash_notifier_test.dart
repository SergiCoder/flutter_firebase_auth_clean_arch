import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/splash_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/state/splash_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

class MockIsAuthenticatedUseCase extends Mock
    implements IsAuthenticatedUseCase {
  @override
  Future<bool> execute() {
    return super.noSuchMethod(
      Invocation.method(#execute, []),
      returnValue: Future<bool>.value(false),
      returnValueForMissingStub: Future<bool>.value(false),
    ) as Future<bool>;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashNotifier', () {
    late MockIsAuthenticatedUseCase mockIsAuthenticatedUseCase;
    late SplashNotifier splashNotifier;

    setUp(() {
      mockIsAuthenticatedUseCase = MockIsAuthenticatedUseCase();

      // Create the SplashNotifier with the mock use case
      splashNotifier = SplashNotifier(
        isAuthenticatedUseCase: mockIsAuthenticatedUseCase,
      );
    });

    test('initial state is SplashInitial', () {
      expect(splashNotifier.state, isA<SplashInitial>());
    });

    group('initialize', () {
      test('emits SplashNavigate with isAuthenticated=true when authenticated',
          () async {
        // Arrange
        when(mockIsAuthenticatedUseCase.execute())
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

      test(
          '''emits SplashNavigate with isAuthenticated=false when not authenticated''',
          () async {
        // Arrange
        when(mockIsAuthenticatedUseCase.execute())
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
        when(mockIsAuthenticatedUseCase.execute())
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
        when(mockIsAuthenticatedUseCase.execute())
            .thenAnswer((_) async => true);

        // Act
        await splashNotifier.retry();

        // Assert
        expect(splashNotifier.state, isA<SplashNavigate>());
        expect(
          (splashNotifier.state as SplashNavigate).isAuthenticated,
          isTrue,
        );
        verify(mockIsAuthenticatedUseCase.execute()).called(1);
      });
    });
  });

  group('splashProvider', () {
    test('creates a SplashNotifier with the correct dependencies', () {
      // Arrange
      final mockIsAuthenticatedUseCase = MockIsAuthenticatedUseCase();
      final container = ProviderContainer(
        overrides: [
          isAuthenticatedUseCaseProvider
              .overrideWithValue(mockIsAuthenticatedUseCase),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final notifier = container.read(splashProvider.notifier);

      // Assert
      expect(notifier, isA<SplashNotifier>());
      expect(container.read(splashProvider), isA<SplashInitial>());
    });
  });
}
