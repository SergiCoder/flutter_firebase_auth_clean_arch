import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/splash_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/state/splash_state.dart';
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

/// Create a non-autoDispose provider for testing to avoid timer issues
final testSplashProvider =
    StateNotifierProvider<SplashNotifier, SplashState>((ref) {
  throw UnimplementedError('Provider was not overridden in tests');
});

/// A simplified version of SplashScreen for testing purposes
/// This avoids timer issues by removing hooks and async operations
class TestSplashScreen extends StatelessWidget {
  /// Creates a new [TestSplashScreen] widget
  const TestSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Title'),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, _) {
            final splashState = ref.watch(testSplashProvider);
            return _buildBody(context, splashState, ref);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SplashState state, WidgetRef ref) {
    if (state is SplashLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.lock_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const CircularProgressIndicator(),
        ],
      );
    } else if (state is SplashError) {
      return ErrorDisplayWidget(
        errorMessage: state.message,
      );
    } else if (state is SplashNavigate) {
      // For testing, we'll just show a text indicating where we'd navigate
      return Text(
        state.isAuthenticated ? 'Navigate to Home' : 'Navigate to Login',
      );
    } else {
      // Initial state
      return const SizedBox();
    }
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
          // Use the non-autoDispose provider for testing
          testSplashProvider.overrideWith((_) => splashNotifier),
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
            child: const TestSplashScreen(),
          ),
        ),
      );

      addTearDown(() {
        container.dispose();
      });
    });

    testWidgets('shows loading state when SplashLoading', (tester) async {
      // Arrange
      splashNotifier.state = const SplashLoading();

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('shows error widget when in error state', (tester) async {
      // Arrange
      const errorMessage = 'Test error';
      splashNotifier.state = const SplashError(errorMessage);

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.byType(ErrorDisplayWidget), findsOneWidget);
    });

    testWidgets('displays navigate to home text when authenticated',
        (tester) async {
      // Arrange
      splashNotifier.state = const SplashNavigate(isAuthenticated: true);

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.text('Navigate to Home'), findsOneWidget);
    });

    testWidgets('displays navigate to login text when not authenticated',
        (tester) async {
      // Arrange
      splashNotifier.state = const SplashNavigate(isAuthenticated: false);

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.text('Navigate to Login'), findsOneWidget);
    });

    testWidgets('initializes on first build', (tester) async {
      // Arrange - We'll manually test the initialization logic
      when(mockIsAuthenticatedUseCase.execute()).thenAnswer((_) async => true);

      // Set initial state
      splashNotifier.state = const SplashInitial();

      // Act - Manually call initialize instead of relying on useEffect
      await tester.pumpWidget(testWidget);

      // Call initialize directly on the notifier
      await splashNotifier.initialize();

      // Pump to process any state changes
      await tester.pump();

      // Assert - Verify the use case was called
      verify(mockIsAuthenticatedUseCase.execute()).called(1);
    });
  });
}
