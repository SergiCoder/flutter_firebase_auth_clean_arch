import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/splash_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/splash_state.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../auth/presentation/mocks/mock_go_router.dart';

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

  group('SplashScreen', () {
    late MockIsAuthenticatedUseCase mockIsAuthenticatedUseCase;
    late MockGoRouter mockGoRouter;
    late ProviderContainer container;
    late Widget testWidget;
    late SplashNotifier splashNotifier;

    setUp(() {
      mockIsAuthenticatedUseCase = MockIsAuthenticatedUseCase();
      mockGoRouter = MockGoRouter();

      // Create a SplashNotifier with the mock use case
      splashNotifier = SplashNotifier(
        isAuthenticatedUseCase: mockIsAuthenticatedUseCase,
      );

      // Create a provider container with overrides
      container = ProviderContainer(
        overrides: [
          splashProvider.overrideWith((ref) => splashNotifier),
          isAuthenticatedUseCaseProvider
              .overrideWithValue(mockIsAuthenticatedUseCase),
        ],
      );

      // Create a test widget with the necessary providers
      testWidget = MaterialApp(
        localizationsDelegates: AppLocalization.localizationDelegates,
        supportedLocales: AppLocalization.supportedLocales,
        home: UncontrolledProviderScope(
          container: container,
          child: MockGoRouterProvider(
            router: mockGoRouter,
            child: const SplashScreen(),
          ),
        ),
      );

      addTearDown(() {
        container.dispose();
      });
    });

    testWidgets('shows loading state when SplashLoading', (tester) async {
      // Arrange
      container.read(splashProvider.notifier).state = const SplashLoading();

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('shows error widget when in error state', (tester) async {
      // Arrange
      const errorMessage = 'Test error';
      container.read(splashProvider.notifier).state =
          const SplashError(errorMessage);

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.byType(ErrorDisplayWidget), findsOneWidget);
    });

    testWidgets('navigates to home when authenticated', (tester) async {
      // Arrange
      when(mockIsAuthenticatedUseCase.execute()).thenAnswer((_) async => true);
      container.read(splashProvider.notifier).state =
          const SplashNavigate(isAuthenticated: true);

      // Act
      await tester.pumpWidget(testWidget);
      await tester.pump();

      // Assert
      verify(mockGoRouter.go(AppRoute.home.path)).called(1);
    });

    testWidgets('navigates to login when not authenticated', (tester) async {
      // Arrange
      when(mockIsAuthenticatedUseCase.execute()).thenAnswer((_) async => false);
      container.read(splashProvider.notifier).state =
          const SplashNavigate(isAuthenticated: false);

      // Act
      await tester.pumpWidget(testWidget);
      await tester.pump();

      // Assert
      verify(mockGoRouter.go(AppRoute.login.path)).called(1);
    });

    testWidgets('initializes on first build', (tester) async {
      // Arrange
      when(mockIsAuthenticatedUseCase.execute()).thenAnswer((_) async => true);

      // Act
      await tester.pumpWidget(testWidget);

      // Trigger the post-frame callback
      await tester.pump();

      // Verify initialize was called
      verify(mockIsAuthenticatedUseCase.execute()).called(1);
    });
  });
}
