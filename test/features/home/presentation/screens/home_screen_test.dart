import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/providers/home_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/providers/state/home_state.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../auth/presentation/mocks/mock_go_router.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => null;
}

class MockSignOutUseCase extends Mock implements SignOutUseCase {
  @override
  Future<void> execute() {
    return super.noSuchMethod(
      Invocation.method(#execute, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    ) as Future<void>;
  }
}

class MockHomeNotifier extends HomeNotifier {
  MockHomeNotifier({
    required super.firebaseAuth,
    required super.signOutUseCase,
  });

  @override
  Future<void> initialize() async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> signOut() async {
    // Call the real implementation to ensure the sign out use case is called
    await super.signOut();
  }
}

/// A special home notifier that tracks initialization calls
class TrackingHomeNotifier extends HomeNotifier {
  /// Creates a new [TrackingHomeNotifier]
  TrackingHomeNotifier({
    required super.firebaseAuth,
    required super.signOutUseCase,
    required this.onInitializeCalled,
  });

  /// Callback that will be called when initialize is called
  final void Function() onInitializeCalled;

  @override
  Future<void> initialize() async {
    onInitializeCalled();
    return super.initialize();
  }
}

// Mock AppLocalizations manually
class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get loginButton => 'Login';

  @override
  String get logoutButton => 'Logout';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get homeTitle => 'Home';

  @override
  String welcome(String email) => 'Welcome, $email!';
}

// Mock localization delegate
class MockAppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  MockAppLocalizationsDelegate(this.mockLocalizations);
  final MockAppLocalizations mockLocalizations;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async => mockLocalizations;

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Set inTest flag to true to skip initialization in the widget
  final testZoneValues = {
    'inTest': true,
  };

  group('HomeScreen', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late MockSignOutUseCase mockSignOutUseCase;
    late MockGoRouter mockGoRouter;
    late ProviderContainer container;
    late MockHomeNotifier mockHomeNotifier;
    late MockAppLocalizations mockLocalizations;
    late Widget testWidget;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockSignOutUseCase = MockSignOutUseCase();
      mockGoRouter = MockGoRouter();
      mockLocalizations = MockAppLocalizations();

      // Create a provider container with overrides
      container = ProviderContainer(
        overrides: [
          // Override the firebase auth provider
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          // Override the home provider to use our mock
          homeProvider.overrideWith(
            (ref) => MockHomeNotifier(
              firebaseAuth: mockFirebaseAuth,
              signOutUseCase: mockSignOutUseCase,
            ),
          ),
          signOutUseCaseProvider.overrideWithValue(mockSignOutUseCase),
        ],
      );

      // Get the notifier instance to manipulate state directly
      mockHomeNotifier =
          container.read(homeProvider.notifier) as MockHomeNotifier;

      // Create a test widget with the necessary providers
      testWidget = MaterialApp(
        localizationsDelegates: [
          // Use mock localization
          MockAppLocalizationsDelegate(mockLocalizations),
          ...AppLocalization.localizationDelegates,
        ],
        supportedLocales: AppLocalization.supportedLocales,
        home: SizedBox(
          width: 800, // Set a reasonable width for testing
          child: UncontrolledProviderScope(
            container: container,
            child: MockGoRouterProvider(
              router: mockGoRouter,
              child: const HomeScreen(),
            ),
          ),
        ),
      );

      addTearDown(() {
        container.dispose();
      });
    });

    testWidgets('renders app bar with title', (tester) async {
      // Run in a test zone to skip initialization
      await runZoned(
        () async {
          // Act
          await tester.pumpWidget(testWidget);
          await tester.pump(); // Use pump instead of pumpAndSettle

          // Assert
          expect(find.byType(AppBar), findsOneWidget);
          expect(find.text('Home'), findsOneWidget);
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets('renders loading state correctly', (tester) async {
      // Run in a test zone to skip initialization
      await runZoned(
        () async {
          // Arrange
          mockHomeNotifier.state = const HomeLoading();

          // Act
          await tester.pumpWidget(testWidget);
          await tester.pump();

          // Assert
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets('renders error state correctly', (tester) async {
      // Run in a test zone to skip initialization
      await runZoned(
        () async {
          // Arrange
          const errorMessage = 'Test error message';
          mockHomeNotifier.state = const HomeError(errorMessage);

          // Act
          await tester.pumpWidget(testWidget);
          await tester.pump();

          // Assert
          expect(find.text(errorMessage), findsOneWidget);
          expect(find.byType(ElevatedButton), findsOneWidget);
          expect(find.text('Logout'), findsOneWidget);
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets('renders unauthenticated state correctly', (tester) async {
      // Run in a test zone to skip initialization
      await runZoned(
        () async {
          // Arrange
          mockHomeNotifier.state = const HomeUnauthenticated();

          // Act
          await tester.pumpWidget(testWidget);
          await tester.pump();

          // Assert
          expect(
            find.text('Invalid email or password'),
            findsOneWidget,
          );
          expect(find.byType(ElevatedButton), findsOneWidget);
          expect(find.text('Login'), findsOneWidget);
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets('renders loaded state correctly', (tester) async {
      // Run in a test zone to skip initialization
      await runZoned(
        () async {
          // Arrange
          const email = 'test@example.com';
          mockHomeNotifier.state = const HomeLoaded(email: email);

          // Act
          await tester.pumpWidget(testWidget);
          await tester.pump();

          // Assert
          expect(find.text('Welcome, $email!'), findsOneWidget);
          expect(find.byType(ElevatedButton), findsOneWidget);
          expect(find.text('Logout'), findsOneWidget);
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets('renders default state correctly', (tester) async {
      // Run in a test zone to skip initialization
      await runZoned(
        () async {
          // Arrange
          mockHomeNotifier.state = const HomeInitial();

          // Act
          await tester.pumpWidget(testWidget);
          await tester.pump();

          // Assert
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets(
        'navigates to login when logout button is pressed in loaded state',
        (tester) async {
      // Run in a test zone to skip initialization
      await runZoned(
        () async {
          // Arrange
          when(mockSignOutUseCase.execute()).thenAnswer((_) async {});
          mockHomeNotifier.state = const HomeLoaded(email: 'test@example.com');

          // Act
          await tester.pumpWidget(testWidget);
          await tester.pump();

          // Find and tap the logout button
          await tester.tap(find.text('Logout'));
          await tester.pump();

          // Assert
          verify(mockGoRouter.go(AppRoute.login.path)).called(1);
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets(
        'navigates to login when logout button is pressed in error state',
        (tester) async {
      // Run in a test zone to skip initialization
      await runZoned(
        () async {
          // Arrange
          when(mockSignOutUseCase.execute()).thenAnswer((_) async {});
          mockHomeNotifier.state = const HomeError('Test error');

          // Act
          await tester.pumpWidget(testWidget);
          await tester.pump();

          // Find and tap the logout button
          await tester.tap(find.text('Logout'));
          await tester.pump();

          // Assert
          verify(mockGoRouter.go(AppRoute.login.path)).called(1);
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets(
        '''navigates to login when login button is pressed in unauthenticated state''',
        (tester) async {
      // Run in a test zone to skip initialization
      await runZoned(
        () async {
          // Arrange
          mockHomeNotifier.state = const HomeUnauthenticated();

          // Act
          await tester.pumpWidget(testWidget);
          await tester.pump();

          // Find and tap the login button
          await tester.tap(find.text('Login'));
          await tester.pump();

          // Assert
          verify(mockGoRouter.go(AppRoute.login.path)).called(1);
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets('initializes home screen in post-frame callback',
        (tester) async {
      // Create a tracking variable
      var initializeCalled = false;

      // Create the notifier instance
      final specialMockNotifier = TrackingHomeNotifier(
        firebaseAuth: mockFirebaseAuth,
        signOutUseCase: mockSignOutUseCase,
        onInitializeCalled: () => initializeCalled = true,
      );

      // Create a container with our special notifier
      final specialContainer = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          homeProvider.overrideWith((_) => specialMockNotifier),
          signOutUseCaseProvider.overrideWithValue(mockSignOutUseCase),
        ],
      );

      // Create a test widget with the special container
      final specialTestWidget = MaterialApp(
        localizationsDelegates: [
          MockAppLocalizationsDelegate(mockLocalizations),
          ...AppLocalization.localizationDelegates,
        ],
        supportedLocales: AppLocalization.supportedLocales,
        home: UncontrolledProviderScope(
          container: specialContainer,
          child: MockGoRouterProvider(
            router: mockGoRouter,
            child: const HomeScreen(),
          ),
        ),
      );

      // Run without the inTest flag to allow initialization
      await tester.pumpWidget(specialTestWidget);

      // Trigger the post-frame callback
      await tester.pump();

      // Wait for any async operations
      await tester.pumpAndSettle();

      // Verify initialize was called
      expect(initializeCalled, isTrue);

      // Clean up
      specialContainer.dispose();
    });
  });
}
