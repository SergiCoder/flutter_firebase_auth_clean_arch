import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/providers/error_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/providers/state/error_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Custom ErrorNotifier that forces an error during processing
class FailingErrorNotifier extends ErrorNotifier {
  @override
  Future<void> processError(String errorMessage) async {
    state = const ErrorProcessing();

    try {
      // Force a failure during the Future.delayed
      await Future<void>.delayed(const Duration(milliseconds: 10));
      throw Exception('Test error during processing');
    } catch (e) {
      // Set the state to ErrorFailed
      state = ErrorFailed(e.toString());
      // Rethrow to simulate the error
      rethrow;
    }
  }
}

void main() {
  group('ErrorProvider Listener', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('state changes correctly during error processing', () async {
      // Arrange
      final states = <ErrorState>[];

      // Set up a listener to record state changes
      container.listen<ErrorState>(
        errorProvider,
        (previous, next) {
          states.add(next);
        },
      );

      // Initial state should be ErrorInitial
      expect(container.read(errorProvider), isA<ErrorInitial>());

      // Act - Process an error
      await container.read(errorProvider.notifier).processError('Test error');

      // Assert - Should have gone through these states:
      // ErrorInitial (initial state)
      // ErrorProcessing (when processing starts)
      // ErrorHandled (when processing completes successfully)
      expect(states.length, equals(2)); // 2 changes after initial state
      expect(states[0], isA<ErrorProcessing>());
      expect(states[1], isA<ErrorHandled>());
    });

    test('state changes to ErrorFailed when an error occurs during processing',
        () async {
      // Arrange - Create a container with a failing notifier
      final failingContainer = ProviderContainer(
        overrides: [
          errorProvider.overrideWith((ref) => FailingErrorNotifier()),
        ],
      );

      final states = <ErrorState>[];

      // Set up a listener to record state changes
      failingContainer.listen<ErrorState>(
        errorProvider,
        (previous, next) {
          states.add(next);
        },
      );

      // Set the initial state to ErrorInitial
      expect(failingContainer.read(errorProvider), isA<ErrorInitial>());

      // Act - Process an error (which will fail)
      try {
        await failingContainer
            .read(errorProvider.notifier)
            .processError('Test error');
        fail('Expected an exception to be thrown');
      } catch (_) {
        // Expected exception
      }

      // Assert - Final state should be ErrorFailed
      expect(failingContainer.read(errorProvider), isA<ErrorFailed>());
      expect((failingContainer.read(errorProvider) as ErrorFailed).message,
          contains('Test error during processing'));

      // Check state transitions
      expect(states.length, equals(2)); // 2 changes after initial state
      expect(states[0], isA<ErrorProcessing>());
      expect(states[1], isA<ErrorFailed>());

      // Clean up
      failingContainer.dispose();
    });

    test('reset changes state to ErrorInitial', () {
      // Arrange - Set state to ErrorFailed
      final notifier = container.read(errorProvider.notifier);
      notifier.state = const ErrorFailed('Test error');

      // Act
      notifier.reset();

      // Assert
      expect(container.read(errorProvider), isA<ErrorInitial>());
    });

    testWidgets('provider works with widgets', (tester) async {
      // Define a simple test widget that uses the provider
      final testWidget = ProviderScope(
        overrides: [
          errorProvider.overrideWith(
            (ref) => ErrorNotifier(),
          ),
        ],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              final errorState = ref.watch(errorProvider);
              return Scaffold(
                body: Center(
                  child: Text(
                    errorState is ErrorInitial
                        ? 'Initial'
                        : errorState is ErrorProcessing
                            ? 'Processing'
                            : errorState is ErrorHandled
                                ? 'Handled'
                                : 'Failed: ${(errorState as ErrorFailed).message}',
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    ref.read(errorProvider.notifier).processError('Test error');
                  },
                  child: const Icon(Icons.error),
                ),
              );
            },
          ),
        ),
      );

      // Render the widget
      await tester.pumpWidget(testWidget);

      // Initial state should show 'Initial'
      expect(find.text('Initial'), findsOneWidget);

      // Tap the button to process an error
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(); // Start of animation

      // Should show 'Processing'
      expect(find.text('Processing'), findsOneWidget);

      // Wait for the processing to complete
      await tester.pump(const Duration(seconds: 2));

      // Should show 'Handled'
      expect(find.text('Handled'), findsOneWidget);
    });
  });
}
