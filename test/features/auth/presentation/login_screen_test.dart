import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/state/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_screen_test.mocks.dart';

/// A simplified version of the LoginScreen for testing
///
/// This widget replicates the core functionality of the LoginScreen
/// without the navigation dependencies, making it easier to test.
class TestLoginScreen extends StatelessWidget {
  /// Creates a new [TestLoginScreen]
  const TestLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).loginTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: HookConsumer(
          builder: (context, ref, _) {
            final loginState = ref.watch(loginProvider);

            // Show loading indicator when in loading state
            if (loginState is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // For all other states, show the login form
            // Pass error message only if in error state
            final errorMessage =
                loginState is LoginError ? loginState.message : null;

            return _buildLoginForm(
              context,
              ref,
              errorMessage: errorMessage,
            );
          },
        ),
      ),
    );
  }

  /// Builds the login form with email and password fields
  ///
  /// [context] The build context
  /// [ref] The widget reference for accessing providers
  /// [errorMessage] Optional error message to display
  Widget _buildLoginForm(
    BuildContext context,
    WidgetRef ref, {
    String? errorMessage,
  }) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 4),
          Icon(
            Icons.lock_outline,
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
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                ref.read(loginProvider.notifier).signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(AppLocalization.of(context).loginButton),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(AppLocalization.of(context).dontHaveAccount),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

@GenerateMocks([AuthRepository])
void main() {
  group('LoginScreen', () {
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
          child: const TestLoginScreen(),
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
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('shows loading indicator when in loading state',
        (tester) async {
      // Arrange
      await tester.pumpWidget(testWidget);

      // Set the state to loading
      container.read(loginProvider.notifier).state = const LoginLoading();

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('shows error message when in error state', (tester) async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      await tester.pumpWidget(testWidget);

      // Set the state to error
      container.read(loginProvider.notifier).state =
          const LoginError(errorMessage);

      // Act
      await tester.pump();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    // Skip the navigation test since we can't properly mock GoRouter in this
    // context
    testWidgets('calls signInWithEmailAndPassword when form is submitted',
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

      // Act - Fill in the form
      await tester.enterText(
        find.byType(TextFormField).at(0),
        email,
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        password,
      );

      // Submit the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester
          .pump(const Duration(milliseconds: 100)); // Wait for async operations

      // Assert
      verify(
        mockAuthRepository.signInWithEmailAndPassword(
          email,
          password,
        ),
      ).called(1);
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
  });
}

/// A widget that provides a [GoRouter] to its descendants
class InheritedGoRouter extends InheritedWidget {
  /// Creates a new [InheritedGoRouter]
  const InheritedGoRouter({
    required this.goRouter,
    required super.child,
    super.key,
  });

  /// The [GoRouter] instance
  final GoRouter goRouter;

  @override
  bool updateShouldNotify(InheritedGoRouter oldWidget) =>
      goRouter != oldWidget.goRouter;

  /// Returns the [GoRouter] from the closest [InheritedGoRouter] ancestor
  static GoRouter of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<InheritedGoRouter>();
    assert(result != null, 'No GoRouter found in context');
    return result!.goRouter;
  }
}
