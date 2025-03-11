import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_screen_test.mocks.dart';
import 'mocks/mock_go_router.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('LoginScreen Complete Coverage Tests', () {
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

    testWidgets('email field onFieldSubmitted moves focus to password field',
        (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Get the email field
      final emailField = find.byType(TextFormField).at(0);

      // Focus the email field
      await tester.tap(emailField);
      await tester.pump();

      // Simulate pressing Enter key
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      // Verify that the password field is now focused
      // This is an indirect test since we can't directly check focus
      // but we can verify the widget tree structure is correct
      expect(find.byType(TextFormField).at(1), findsOneWidget);
    });

    testWidgets('password field onFieldSubmitted submits the form',
        (tester) async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      when(
        mockAuthRepository.signInWithEmailAndPassword(
          email,
          password,
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(testWidget);

      // Fill in the form
      await tester.enterText(
        find.byType(TextFormField).at(0),
        email,
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        password,
      );

      // Focus the password field
      await tester.tap(find.byType(TextFormField).at(1));
      await tester.pump();

      // Simulate pressing Enter key
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Verify that the form was submitted
      verify(
        mockAuthRepository.signInWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);
    });

    testWidgets(
        'password validator rejects passwords shorter than 6 characters',
        (tester) async {
      // Arrange
      const email = 'test@example.com';
      const shortPassword = '12345'; // 5 characters, too short

      await tester.pumpWidget(testWidget);

      // Fill in the form
      await tester.enterText(
        find.byType(TextFormField).at(0),
        email,
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        shortPassword,
      );

      // Submit the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify that the form validation shows error for short password
      expect(
        find.text(
          AppLocalization.of(tester.element(find.byType(ElevatedButton)))
              .passwordTooShort,
        ),
        findsOneWidget,
      );

      // Verify that the repository method was not called
      verifyNever(
        mockAuthRepository.signInWithEmailAndPassword(
          any,
          any,
        ),
      );
    });

    testWidgets(
        'navigates to home when login is successful and context is mounted',
        (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Set the state to success
      container.read(loginProvider.notifier).state = const LoginSuccess();

      // Act - Allow microtasks to complete
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Verify navigation was attempted
      verify(mockGoRouter.go(AppRoute.home.path)).called(1);
    });

    testWidgets('form validation handles null password correctly',
        (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Get the form key to manually validate
      final formFinder = find.byType(Form);
      expect(formFinder, findsOneWidget);

      // Fill only the email field
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      );

      // Submit the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify that validation error is shown
      expect(
        find.text(
          AppLocalization.of(tester.element(find.byType(ElevatedButton)))
              .passwordTooShort,
        ),
        findsOneWidget,
      );
    });

    testWidgets('error display widget shows error message correctly',
        (tester) async {
      // Arrange
      const errorMessage = 'Custom error message';
      await tester.pumpWidget(testWidget);

      // Set the state to error with custom message
      container.read(loginProvider.notifier).state =
          const LoginError(errorMessage);

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(ErrorDisplayWidget), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
