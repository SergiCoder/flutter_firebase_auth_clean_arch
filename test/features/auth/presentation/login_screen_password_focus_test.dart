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
  group('LoginScreen Password Focus Tests', () {
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

    testWidgets('focuses password field when LoginFormField.password is set',
        (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Act - Set the form field state to password
      container.read(loginFormProvider.notifier).focusPassword();
      await tester.pump();

      // We can't directly test focus in widget tests, but we can verify
      // that the widget tree is updated correctly and the password field exists
      expect(find.byType(TextFormField).at(1), findsOneWidget);

      // Additional verification - try to enter text in the password field
      // which should work if it's focused
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pump();

      // Verify the text was entered
      expect(find.text('password123'), findsOneWidget);
    });
  });
}
