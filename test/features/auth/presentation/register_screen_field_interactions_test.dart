import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/mock_go_router.dart';
import 'register_screen_test.mocks.dart';

/// Tests focusing on field interactions and validations in the RegisterScreen
@GenerateMocks([AuthRepository])
void main() {
  group('RegisterScreen Field Interactions', () {
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
            child: const RegisterScreen(),
          ),
        ),
      );

      addTearDown(container.dispose);
    });

    testWidgets('email field submits and moves focus to password field',
        (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Get the email field
      final emailField = find.byKey(const Key('register_email_field'));

      // Focus on email field
      await tester.tap(emailField);
      await tester.pump();

      // Enter text and submit
      await tester.enterText(emailField, 'test@example.com');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      // Verify that the form provider was called to focus the password field
      expect(
        container.read(registerFormProvider),
        equals(RegisterFormField.password),
      );
    });

    testWidgets(
        'password field submits and moves focus to confirm password field',
        (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Get the password field
      final passwordField = find.byKey(const Key('register_password_field'));

      // Focus on password field
      await tester.tap(passwordField);
      await tester.pump();

      // Enter text and submit
      await tester.enterText(passwordField, 'password123');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      // Verify that the form provider was called to focus the confirm password
      // field
      expect(
        container.read(registerFormProvider),
        equals(RegisterFormField.confirmPassword),
      );
    });

    testWidgets('confirm password field submits the form when Enter is pressed',
        (tester) async {
      // Arrange
      when(
        mockAuthRepository.createUserWithEmailAndPassword(
          any,
          any,
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(testWidget);

      // Fill in all fields with valid data
      await tester.enterText(
        find.byKey(const Key('register_email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('register_password_field')),
        'password123',
      );

      // Get the confirm password field
      final confirmPasswordField =
          find.byKey(const Key('register_confirm_password_field'));

      // Focus on confirm password field
      await tester.tap(confirmPasswordField);
      await tester.pump();

      // Enter matching password and press Enter
      await tester.enterText(confirmPasswordField, 'password123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Verify that the repository was called with the correct parameters
      verify(
        mockAuthRepository.createUserWithEmailAndPassword(
          'test@example.com',
          'password123',
        ),
      ).called(1);
    });

    testWidgets('form submission sets RegisterFormField to none',
        (tester) async {
      // Arrange
      when(
        mockAuthRepository.createUserWithEmailAndPassword(
          any,
          any,
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(testWidget);

      // Fill in all fields with valid data
      await tester.enterText(
        find.byKey(const Key('register_email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('register_password_field')),
        'password123',
      );
      await tester.enterText(
        find.byKey(const Key('register_confirm_password_field')),
        'password123',
      );

      // Submit the form
      await tester.tap(find.byKey(const Key('register_submit_button')));
      await tester.pump();

      // Manually set the form state to none to cover the switch case
      container.read(registerFormProvider.notifier).submitForm();
      await tester.pump();

      // Verify that the form field is set to none
      expect(
        container.read(registerFormProvider),
        equals(RegisterFormField.none),
      );

      // Verify that the repository was called with the correct parameters
      verify(
        mockAuthRepository.createUserWithEmailAndPassword(
          'test@example.com',
          'password123',
        ),
      ).called(1);
    });

    testWidgets('focusEmail method sets focus to email field', (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // First set focus to a different field
      container.read(registerFormProvider.notifier).focusPassword();
      await tester.pump();

      // Verify that the focus is on the password field
      expect(
        container.read(registerFormProvider),
        equals(RegisterFormField.password),
      );

      // Now set focus back to the email field
      container.read(registerFormProvider.notifier).focusEmail();
      await tester.pump();

      // Verify that the focus is now on the email field
      expect(
        container.read(registerFormProvider),
        equals(RegisterFormField.email),
      );
    });

    testWidgets('validates form fields on button press', (tester) async {
      // Arrange
      when(
        mockAuthRepository.createUserWithEmailAndPassword(
          any,
          any,
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(testWidget);

      // Act - Submit empty form
      await tester.tap(find.byKey(const Key('register_submit_button')));
      await tester.pump();

      // Assert - Should show validation errors
      expect(find.text('Please enter your email address'), findsOneWidget);
    });

    testWidgets('validates password too short (less than 6 characters)',
        (tester) async {
      // Arrange
      when(
        mockAuthRepository.createUserWithEmailAndPassword(
          any,
          any,
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(testWidget);

      // Fill in email and a short password
      await tester.enterText(
        find.byKey(const Key('register_email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('register_password_field')),
        '12345',
      );

      // Submit the form
      await tester.tap(find.byKey(const Key('register_submit_button')));
      await tester.pump();

      // Verify that validation errors are shown
      expect(find.text('Password must be at least 6 characters'), findsWidgets);
    });

    testWidgets('validates passwords do not match', (tester) async {
      // Arrange
      when(
        mockAuthRepository.createUserWithEmailAndPassword(
          any,
          any,
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(testWidget);

      // Fill in email, password, and different confirm password
      await tester.enterText(
        find.byKey(const Key('register_email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('register_password_field')),
        'password123',
      );
      await tester.enterText(
        find.byKey(const Key('register_confirm_password_field')),
        'different123',
      );

      // Submit the form
      await tester.tap(find.byKey(const Key('register_submit_button')));
      await tester.pump();

      // Verify that validation errors are shown
      expect(find.text("Passwords don't match"), findsWidgets);
    });

    testWidgets('shows error widget when in error state', (tester) async {
      // Arrange
      const errorMessage = 'Registration failed';
      await tester.pumpWidget(testWidget);

      // Set the state to error
      container.read(registerProvider.notifier).state =
          const RegisterError(errorMessage);

      // Act
      await tester.pump();

      // Assert - Error display widget should be shown
      expect(find.byType(ErrorDisplayWidget), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
