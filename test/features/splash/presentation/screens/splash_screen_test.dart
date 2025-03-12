import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/splash_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/state/splash_state.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../auth/presentation/mocks/mock_go_router.dart';

// Mock the IsAuthenticatedUseCase
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

// Mock SplashNotifier to control state for testing
class MockSplashNotifier extends SplashNotifier {
  MockSplashNotifier({required super.isAuthenticatedUseCase});

  @override
  set state(SplashState value) {
    super.state = value;
  }

  @override
  Future<void> initialize() async {
    // Do nothing in the mock to avoid actual initialization
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreen', () {
    late MockIsAuthenticatedUseCase mockIsAuthenticatedUseCase;
    late MockGoRouter mockGoRouter;
    late ProviderContainer container;
    late MockSplashNotifier mockSplashNotifier;
    late Widget testWidget;

    setUp(() {
      mockIsAuthenticatedUseCase = MockIsAuthenticatedUseCase();
      mockGoRouter = MockGoRouter();
      mockSplashNotifier = MockSplashNotifier(
        isAuthenticatedUseCase: mockIsAuthenticatedUseCase,
      );

      // Create a provider container with overrides
      container = ProviderContainer(
        overrides: [
          // Override the splash provider to use our mock
          splashProvider.overrideWith((_) => mockSplashNotifier),
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

    testWidgets('initializes on first build', (tester) async {
      // Arrange
      when(mockIsAuthenticatedUseCase.execute()).thenAnswer((_) async => true);

      // Act
      await tester.pumpWidget(testWidget);

      // Simulate the post-frame callback
      await tester.pump();

      // Set state to loading to simulate initialization
      mockSplashNotifier.state = const SplashLoading();
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('shows loading state during initialization', (tester) async {
      // Arrange
      when(mockIsAuthenticatedUseCase.execute()).thenAnswer((_) async => true);

      // Act
      await tester.pumpWidget(testWidget);

      // Set state to loading
      mockSplashNotifier.state = const SplashLoading();
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('navigates to home when authenticated', (tester) async {
      // Arrange
      when(mockIsAuthenticatedUseCase.execute()).thenAnswer((_) async => true);

      // Act
      await tester.pumpWidget(testWidget);

      // Set state to navigate with authenticated=true
      mockSplashNotifier.state = const SplashNavigate(isAuthenticated: true);
      await tester.pump();
      await tester
          .pump(const Duration(milliseconds: 10)); // Allow microtask to run

      // Assert
      verify(mockGoRouter.go(AppRoute.home.path)).called(1);
    });

    testWidgets('navigates to login when not authenticated', (tester) async {
      // Arrange
      when(mockIsAuthenticatedUseCase.execute()).thenAnswer((_) async => false);

      // Act
      await tester.pumpWidget(testWidget);

      // Set state to navigate with authenticated=false
      mockSplashNotifier.state = const SplashNavigate(isAuthenticated: false);
      await tester.pump();
      await tester
          .pump(const Duration(milliseconds: 10)); // Allow microtask to run

      // Assert
      verify(mockGoRouter.go(AppRoute.login.path)).called(1);
    });

    testWidgets('shows error state when initialization fails', (tester) async {
      // Arrange
      when(mockIsAuthenticatedUseCase.execute())
          .thenThrow(Exception('Test error'));

      // Act
      await tester.pumpWidget(testWidget);

      // Set state to error
      mockSplashNotifier.state = const SplashError('Test error');
      await tester.pump();

      // Assert
      expect(find.byType(ErrorDisplayWidget), findsOneWidget);
    });
  });
}
