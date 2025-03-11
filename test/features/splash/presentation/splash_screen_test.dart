import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/splash_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/splash_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/splash_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../auth/presentation/mocks/mock_go_router.dart';

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

  group('SplashScreen', () {
    late MockAuthRepository mockAuthRepository;
    late MockGoRouter mockGoRouter;
    late ProviderContainer container;
    late Widget testWidget;
    late SplashNotifier splashNotifier;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockGoRouter = MockGoRouter();

      // Create a SplashNotifier with the mock repository
      splashNotifier = SplashNotifier(
        authRepository: mockAuthRepository,
      );

      // Create a provider container with overrides
      container = ProviderContainer(
        overrides: [
          splashProvider.overrideWith((ref) => splashNotifier),
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );

      // Create a test widget with the necessary providers and localization
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

    testWidgets('renders loading state correctly', (tester) async {
      // Arrange
      container.read(splashProvider.notifier).state = const SplashLoading();

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error state correctly', (tester) async {
      // Arrange
      const errorMessage = 'An error occurred';
      container.read(splashProvider.notifier).state =
          const SplashError(errorMessage);

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('navigates to login when not authenticated', (tester) async {
      // Arrange
      container.read(splashProvider.notifier).state =
          const SplashNavigate(isAuthenticated: false);

      // Act
      await tester.pumpWidget(testWidget);

      // Allow microtask to complete
      await tester.pumpAndSettle();

      // Assert - verify go was called with login route
      verify(mockGoRouter.go('/login')).called(1);
    });

    testWidgets('navigates to home when authenticated', (tester) async {
      // Arrange
      container.read(splashProvider.notifier).state =
          const SplashNavigate(isAuthenticated: true);

      // Act
      await tester.pumpWidget(testWidget);

      // Allow microtask to complete
      await tester.pumpAndSettle();

      // Assert - verify go was called with home route
      verify(mockGoRouter.go('/')).called(1);
    });

    testWidgets('initializes on first build', (tester) async {
      // Arrange
      when(mockAuthRepository.isAuthenticated()).thenAnswer((_) async => true);

      // Act
      await tester.pumpWidget(testWidget);

      // Allow post-frame callback and microtask to complete
      await tester.pumpAndSettle();

      // Assert - verify go was called with home route
      verify(mockGoRouter.go('/')).called(1);
    });
  });
}
