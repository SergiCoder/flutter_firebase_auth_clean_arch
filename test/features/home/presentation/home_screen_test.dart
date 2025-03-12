import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/providers/home_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/providers/state/home_state.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../auth/presentation/mocks/mock_go_router.dart';

class MockSignOutUseCase extends Mock implements SignOutUseCase {
  @override
  Future<void> execute() async {
    return super.noSuchMethod(
      Invocation.method(#execute, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeScreen', () {
    late MockSignOutUseCase mockSignOutUseCase;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockGoRouter mockGoRouter;
    late ProviderContainer container;
    late Widget testWidget;
    late HomeNotifier homeNotifier;

    setUp(() {
      mockSignOutUseCase = MockSignOutUseCase();
      mockFirebaseAuth = MockFirebaseAuth();
      mockGoRouter = MockGoRouter();

      // Create a HomeNotifier with the mock dependencies
      homeNotifier = HomeNotifier(
        firebaseAuth: mockFirebaseAuth,
        signOutUseCase: mockSignOutUseCase,
      );

      // Create a provider container with overrides
      container = ProviderContainer(
        overrides: [
          homeProvider.overrideWith((ref) => homeNotifier),
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          signOutUseCaseProvider.overrideWithValue(mockSignOutUseCase),
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
            child: const HomeScreen(),
          ),
        ),
      );

      addTearDown(() {
        container.dispose();
      });
    });

    testWidgets('renders loading state initially', (tester) async {
      // Arrange
      container.read(homeProvider.notifier).state = const HomeLoading();

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error state correctly', (tester) async {
      // Arrange
      const errorMessage = 'An error occurred';
      container.read(homeProvider.notifier).state =
          const HomeError(errorMessage);

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders loaded state correctly', (tester) async {
      // Arrange
      const email = 'test@example.com';
      container.read(homeProvider.notifier).state =
          const HomeLoaded(email: email);

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('logs out when logout button is pressed in error state',
        (tester) async {
      // Arrange
      const errorMessage = 'An error occurred';
      container.read(homeProvider.notifier).state =
          const HomeError(errorMessage);

      // Act
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockSignOutUseCase.execute()).called(1);
    });

    testWidgets('logs out when logout button is pressed in loaded state',
        (tester) async {
      // Arrange
      const email = 'test@example.com';
      container.read(homeProvider.notifier).state =
          const HomeLoaded(email: email);

      // Act
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockSignOutUseCase.execute()).called(1);
    });
  });
}
