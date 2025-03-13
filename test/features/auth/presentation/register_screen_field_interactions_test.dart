// ignore_for_file: use_setters_to_change_properties, document_ignores

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../core/presentation/widgets/mock_error_message_localizer.dart';
import 'mocks/mock_go_router.dart';
import 'register_screen_test.mocks.dart';

// Mock CreateUserWithEmailAndPasswordUseCase manually
class MockCreateUserWithEmailAndPasswordUseCase extends Mock
    implements CreateUserWithEmailAndPasswordUseCase {
  @override
  Future<void> execute(String email, String password) async {
    return super.noSuchMethod(
      Invocation.method(#execute, [email, password]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

// Create a test register notifier that allows direct state manipulation
class TestRegisterNotifier extends RegisterNotifier {
  TestRegisterNotifier({required super.createUserUseCase});

  void updateState(RegisterState newState) {
    state = newState;
  }
}

/// Tests focusing on field interactions and validations in the RegisterScreen
@GenerateMocks([AuthRepository])
void main() {
  group('RegisterScreen Field Interactions', () {
    late MockAuthRepository mockAuthRepository;
    late MockGoRouter mockGoRouter;
    late MockCreateUserWithEmailAndPasswordUseCase mockCreateUserUseCase;
    late TestRegisterNotifier testRegisterNotifier;
    late Widget testWidget;

    // Create a test zone value to skip initialization and avoid timer issues
    final testZoneValues = {
      'inTest': true,
    };

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockGoRouter = MockGoRouter();
      mockCreateUserUseCase = MockCreateUserWithEmailAndPasswordUseCase();
      testRegisterNotifier =
          TestRegisterNotifier(createUserUseCase: mockCreateUserUseCase);

      // Create a test widget with the necessary providers and localization
      testWidget = MaterialApp(
        localizationsDelegates: AppLocalization.localizationDelegates,
        supportedLocales: AppLocalization.supportedLocales,
        home: ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepository),
            registerProvider.overrideWith((_) => testRegisterNotifier),
            errorMessageLocalizerProviderOverride,
          ],
          child: MockGoRouterProvider(
            router: mockGoRouter,
            child: const RegisterScreen(),
          ),
        ),
      );
    });

    testWidgets('validates form fields on button press', (tester) async {
      // Run in a test zone to skip initialization and avoid timer issues
      await runZoned(
        () async {
          // Arrange
          when(
            mockCreateUserUseCase.execute(
              'test@example.com',
              'password123',
            ),
          ).thenAnswer((_) async {});

          await tester.pumpWidget(testWidget);

          // Act - Submit empty form
          await tester.tap(find.byKey(const Key('register_submit_button')));
          await tester.pump();

          // Assert - Should show validation errors
          expect(find.text('Please enter your email address'), findsOneWidget);
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets('validates password too short (less than 6 characters)',
        (tester) async {
      // Run in a test zone to skip initialization and avoid timer issues
      await runZoned(
        () async {
          // Arrange
          when(
            mockCreateUserUseCase.execute(
              'test@example.com',
              'password123',
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
          expect(
            find.text('Password must be at least 6 characters'),
            findsWidgets,
          );
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets('validates passwords do not match', (tester) async {
      // Run in a test zone to skip initialization and avoid timer issues
      await runZoned(
        () async {
          // Arrange
          when(
            mockCreateUserUseCase.execute(
              'test@example.com',
              'password123',
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
        },
        zoneValues: testZoneValues,
      );
    });

    testWidgets('shows error widget when in error state', (tester) async {
      // Run in a test zone to skip initialization and avoid timer issues
      await runZoned(
        () async {
          // Arrange
          const errorMessage = 'Registration failed';
          await tester.pumpWidget(testWidget);

          // Set the state to error
          testRegisterNotifier.updateState(const RegisterError(errorMessage));

          // Act
          await tester.pump();

          // Assert - Error display widget should be shown
          expect(find.byType(ErrorDisplayWidget), findsOneWidget);
          expect(find.text(errorMessage), findsOneWidget);
        },
        zoneValues: testZoneValues,
      );
    });
  });
}
