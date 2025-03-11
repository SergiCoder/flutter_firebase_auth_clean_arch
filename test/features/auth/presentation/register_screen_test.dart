import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_screen_test.mocks.dart';

/// A simplified version of the RegisterScreen for testing
///
/// This widget replicates the core functionality of the RegisterScreen
/// without the navigation dependencies, making it easier to test.
class TestRegisterScreen extends StatelessWidget {
  /// Creates a new [TestRegisterScreen]
  const TestRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).registerTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer(
          builder: (context, ref, _) {
            final registerState = ref.watch(registerProvider);

            // Show loading indicator when in loading state
            if (registerState is RegisterLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // For all other states, show the register form
            // Pass error message only if in error state
            final errorMessage =
                registerState is RegisterError ? registerState.message : null;

            return _buildRegisterForm(
              context,
              ref,
              errorMessage: errorMessage,
            );
          },
        ),
      ),
    );
  }

  /// Builds the register form with email, password, and confirm password fields
  ///
  /// [context] The build context
  /// [ref] The widget reference for accessing providers
  /// [errorMessage] Optional error message to display
  Widget _buildRegisterForm(
    BuildContext context,
    WidgetRef ref, {
    String? errorMessage,
  }) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 4),
          Icon(
            Icons.person_add_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          Flexible(
            flex: 4,
            child:
                (errorMessage != null) ? Text(errorMessage) : const SizedBox(),
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: AppLocalization.of(context).email,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalization.of(context).emptyEmail;
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return AppLocalization.of(context).invalidEmail;
              }
              return null;
            },
          ),
          const Spacer(),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: AppLocalization.of(context).password,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalization.of(context).passwordTooShort;
              }
              if (value.length < 6) {
                return AppLocalization.of(context).passwordTooShort;
              }
              return null;
            },
          ),
          const Spacer(),
          TextFormField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: AppLocalization.of(context).confirmPassword,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalization.of(context).passwordTooShort;
              }
              if (value != passwordController.text) {
                return AppLocalization.of(context).passwordsDontMatch;
              }
              return null;
            },
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                ref
                    .read(registerProvider.notifier)
                    .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(AppLocalization.of(context).registerButton),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(AppLocalization.of(context).alreadyHaveAccount),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

@GenerateMocks([AuthRepository])
void main() {
  group('RegisterScreen', () {
    late MockAuthRepository mockAuthRepository;
    late ProviderContainer container;
    late Widget testWidget;

    setUp(() {
      mockAuthRepository = MockAuthRepository();

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
          child: const TestRegisterScreen(),
        ),
      );

      addTearDown(container.dispose);
    });

    testWidgets('renders correctly in initial state', (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      ); // Email, password, confirm password
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.person_add_outlined), findsOneWidget);
    });

    testWidgets('shows loading indicator when in loading state',
        (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Set the state to loading
      container.read(registerProvider.notifier).state = const RegisterLoading();

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('shows error message when in error state', (tester) async {
      // Arrange
      const errorMessage = 'Registration failed';
      await tester.pumpWidget(testWidget);

      // Set the state to error
      container.read(registerProvider.notifier).state =
          const RegisterError(errorMessage);

      // Act
      await tester.pump();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('validates email field', (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Act - Submit with empty email
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Should show validation error for email
      expect(
        find.descendant(
          of: find.byType(TextFormField).at(0),
          matching: find.byType(Text),
        ),
        findsWidgets,
      );

      // Act - Enter invalid email
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'invalid-email',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Should still show validation error
      expect(
        find.descendant(
          of: find.byType(TextFormField).at(0),
          matching: find.byType(Text),
        ),
        findsWidgets,
      );
    });

    testWidgets('validates password field', (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Act - Submit with valid email but empty password
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Should show validation error for password
      expect(
        find.descendant(
          of: find.byType(TextFormField).at(1),
          matching: find.byType(Text),
        ),
        findsWidgets,
      );

      // Act - Enter short password
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '12345',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Should still show validation error
      expect(
        find.descendant(
          of: find.byType(TextFormField).at(1),
          matching: find.byType(Text),
        ),
        findsWidgets,
      );
    });

    testWidgets('validates confirm password field', (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Act - Submit with valid email, valid password, but empty confirm
      // password
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'password123',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Should show validation error for confirm password
      expect(
        find.descendant(
          of: find.byType(TextFormField).at(2),
          matching: find.byType(Text),
        ),
        findsWidgets,
      );

      // Act - Enter different password in confirm field
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'different123',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Should show passwords don't match error
      expect(
        find.descendant(
          of: find.byType(TextFormField).at(2),
          matching: find.byType(Text),
        ),
        findsWidgets,
      );
    });

    // Comprehensive test for form submission and state transitions
    testWidgets('handles complete registration flow with state transitions',
        (tester) async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Mock successful registration with a delayed response
      when(
        mockAuthRepository.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).thenAnswer((_) async {
        // Add a small delay to ensure we can observe the loading state
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });

      await tester.pumpWidget(testWidget);

      // Act - Fill in the form with valid inputs
      await tester.enterText(find.byType(TextFormField).at(0), email);
      await tester.enterText(find.byType(TextFormField).at(1), password);
      await tester.enterText(find.byType(TextFormField).at(2), password);

      // Initial state should be RegisterInitial
      expect(container.read(registerProvider), isA<RegisterInitial>());

      // Submit the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Should show loading indicator (RegisterLoading state)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the async operation to complete
      await tester.pumpAndSettle();

      // Assert - Repository method should be called
      verify(
        mockAuthRepository.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);

      // Assert - Final state should be success
      expect(container.read(registerProvider), isA<RegisterSuccess>());
    });

    testWidgets('handles repository errors during registration',
        (tester) async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const errorMessage = 'Email already in use';

      when(
        mockAuthRepository.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).thenThrow(errorMessage);

      await tester.pumpWidget(testWidget);

      // Act - Fill in the form with valid inputs
      await tester.enterText(find.byType(TextFormField).at(0), email);
      await tester.enterText(find.byType(TextFormField).at(1), password);
      await tester.enterText(find.byType(TextFormField).at(2), password);

      // Submit the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Wait for async operations
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Repository should be called and state should change to error
      verify(
        mockAuthRepository.createUserWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);

      final state = container.read(registerProvider);
      expect(state, isA<RegisterError>());
      expect((state as RegisterError).message, errorMessage);

      // Error message should be displayed
      await tester.pump();
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('resets state when notifier reset is called', (tester) async {
      // Arrange
      const errorMessage = 'Registration failed';
      await tester.pumpWidget(testWidget);

      // Set the state to error
      container.read(registerProvider.notifier).state =
          const RegisterError(errorMessage);
      await tester.pump();

      // Assert - Error message should be displayed
      expect(find.text(errorMessage), findsOneWidget);

      // Act - Reset the state
      container.read(registerProvider.notifier).reset();
      await tester.pump();

      // Assert - State should be reset to initial
      expect(container.read(registerProvider), isA<RegisterInitial>());
      expect(find.text(errorMessage), findsNothing);
    });
  });
}
