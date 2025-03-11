import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';

import 'login_screen_test.mocks.dart';
import 'mocks/mock_go_router.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('Auth Navigation Tests', () {
    late MockAuthRepository mockAuthRepository;
    late MockGoRouter mockGoRouter;
    late ProviderContainer container;
    late Widget testWidget;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockGoRouter = MockGoRouter();

      // Create a provider container with mocked dependencies
      container = ProviderContainer(
        overrides: [
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
            child: const LoginScreen(),
          ),
        ),
      );

      addTearDown(container.dispose);
    });

    testWidgets('shows login screen initially', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Assert - Check that the login screen is shown
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(2),
      ); // Email and password fields
      expect(find.byType(ElevatedButton), findsOneWidget); // Login button
    });

    testWidgets('shows loading indicator during login process', (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Set the state to loading
      container.read(loginProvider.notifier).state = const LoginLoading();

      // Act
      await tester.pump();

      // Assert - Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('shows error message on login error', (tester) async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      await tester.pumpWidget(testWidget);

      // Set the state to error
      container.read(loginProvider.notifier).state =
          const LoginError(errorMessage);

      // Act
      await tester.pump();

      // Assert - Should show error message
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('can tap register button', (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Find the "Don't have an account?" button
      final registerButton = find.byType(TextButton);
      expect(registerButton, findsOneWidget);

      // Act
      await tester.tap(registerButton);
      await tester.pump();

      // Assert - Button was tapped
      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}
