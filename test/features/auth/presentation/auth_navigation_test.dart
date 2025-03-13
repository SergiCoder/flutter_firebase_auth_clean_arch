// ignore_for_file: use_setters_to_change_properties, document_ignores

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../core/presentation/widgets/mock_error_message_localizer.dart';
import 'mocks/mock_go_router.dart';

// Mock SignInWithEmailAndPasswordUseCase manually
class MockSignInWithEmailAndPasswordUseCase extends Mock
    implements SignInWithEmailAndPasswordUseCase {
  @override
  Future<void> execute(String email, String password) async {
    return super.noSuchMethod(
      Invocation.method(#execute, [email, password]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

// Create a test login notifier that allows direct state manipulation
class TestLoginNotifier extends LoginNotifier {
  TestLoginNotifier({required super.signInUseCase});

  void updateState(LoginState newState) {
    state = newState;
  }
}

@GenerateMocks([AuthRepository])
void main() {
  group('Auth Navigation Tests', () {
    late MockGoRouter mockGoRouter;
    late MockSignInWithEmailAndPasswordUseCase mockSignInUseCase;
    late TestLoginNotifier testLoginNotifier;
    late Widget testWidget;

    setUp(() {
      mockGoRouter = MockGoRouter();
      mockSignInUseCase = MockSignInWithEmailAndPasswordUseCase();
      testLoginNotifier = TestLoginNotifier(signInUseCase: mockSignInUseCase);

      // Create a test widget with the necessary providers and localization
      testWidget = MaterialApp(
        localizationsDelegates: AppLocalization.localizationDelegates,
        supportedLocales: AppLocalization.supportedLocales,
        home: ProviderScope(
          overrides: [
            loginProvider.overrideWith((_) => testLoginNotifier),
            errorMessageLocalizerProviderOverride,
          ],
          child: MockGoRouterProvider(
            router: mockGoRouter,
            child: const LoginScreen(),
          ),
        ),
      );
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
      testLoginNotifier.updateState(const LoginLoading());

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
      testLoginNotifier.updateState(const LoginError(errorMessage));

      // Act
      await tester.pump();

      // Assert - Should show error message
      expect(find.byType(ErrorDisplayWidget), findsOneWidget);

      // Verify the error message is passed to the ErrorDisplayWidget
      final errorWidget = tester.widget<ErrorDisplayWidget>(
        find.byType(ErrorDisplayWidget),
      );
      expect(errorWidget.errorMessage, equals(errorMessage));
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
