import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/splash_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/state/splash_state.dart';
import 'package:flutter_test/flutter_test.dart';
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
  group('SplashNotifier', () {
    late MockIsAuthenticatedUseCase mockIsAuthenticatedUseCase;
    late SplashNotifier splashNotifier;

    setUp(() {
      mockIsAuthenticatedUseCase = MockIsAuthenticatedUseCase();
      splashNotifier = SplashNotifier(
        isAuthenticatedUseCase: mockIsAuthenticatedUseCase,
      );
    });

    test('initial state is SplashInitial', () {
      // Assert
      expect(splashNotifier.state, isA<SplashInitial>());
    });

    group('initialize', () {
      test('sets state to SplashLoading then SplashNavigate when authenticated',
          () async {
        // Arrange
        when(mockIsAuthenticatedUseCase.execute())
            .thenAnswer((_) async => true);

        // Act
        await splashNotifier.initialize();

        // Assert
        verify(mockIsAuthenticatedUseCase.execute()).called(1);
        expect(splashNotifier.state, isA<SplashNavigate>());
        expect(
            (splashNotifier.state as SplashNavigate).isAuthenticated, isTrue);
      });

      test(
          'sets state to SplashLoading then SplashNavigate when not authenticated',
          () async {
        // Arrange
        when(mockIsAuthenticatedUseCase.execute())
            .thenAnswer((_) async => false);

        // Act
        await splashNotifier.initialize();

        // Assert
        verify(mockIsAuthenticatedUseCase.execute()).called(1);
        expect(splashNotifier.state, isA<SplashNavigate>());
        expect(
            (splashNotifier.state as SplashNavigate).isAuthenticated, isFalse);
      });

      test('sets state to SplashError when an exception occurs', () async {
        // Arrange
        final error = Exception('Test error');
        when(mockIsAuthenticatedUseCase.execute()).thenThrow(error);

        // Act
        await splashNotifier.initialize();

        // Assert
        verify(mockIsAuthenticatedUseCase.execute()).called(1);
        expect(splashNotifier.state, isA<SplashError>());
        expect((splashNotifier.state as SplashError).message,
            contains('Exception: Test error'));
      });
    });

    test('retry calls initialize', () async {
      // Arrange
      when(mockIsAuthenticatedUseCase.execute()).thenAnswer((_) async => true);

      // Act
      await splashNotifier.retry();

      // Assert
      verify(mockIsAuthenticatedUseCase.execute()).called(1);
      expect(splashNotifier.state, isA<SplashNavigate>());
      expect((splashNotifier.state as SplashNavigate).isAuthenticated, isTrue);
    });

    test('reset sets state to SplashInitial', () {
      // Arrange
      splashNotifier.state = const SplashLoading();

      // Act
      splashNotifier.reset();

      // Assert
      expect(splashNotifier.state, isA<SplashInitial>());
    });
  });
}
