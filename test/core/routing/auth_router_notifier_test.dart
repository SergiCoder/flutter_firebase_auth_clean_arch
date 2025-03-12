import 'dart:async';

import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_router_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mock for GetAuthStateChangesUseCase
@GenerateMocks([GetAuthStateChangesUseCase])
import 'auth_router_notifier_test.mocks.dart';

void main() {
  group('AuthRouterNotifier', () {
    late MockGetAuthStateChangesUseCase mockGetAuthStateChangesUseCase;
    late StreamController<bool> authStateController;

    setUp(() {
      mockGetAuthStateChangesUseCase = MockGetAuthStateChangesUseCase();
      authStateController = StreamController<bool>.broadcast();

      // Setup the mock use case to return our controlled stream
      when(mockGetAuthStateChangesUseCase.execute())
          .thenAnswer((_) => authStateController.stream);
    });

    tearDown(() {
      // Clean up resources
      authStateController.close();
    });

    test('should initialize with unauthenticated state by default', () {
      // Create the notifier with the mock use case
      final authRouterNotifier = AuthRouterNotifier(
        getAuthStateChangesUseCase: mockGetAuthStateChangesUseCase,
      );

      // Assert
      expect(authRouterNotifier.isAuthenticated, isFalse);

      // Clean up
      authRouterNotifier.dispose();
    });

    test('should update authentication state when stream emits new value',
        () async {
      // Create the notifier with the mock use case
      final authRouterNotifier = AuthRouterNotifier(
        getAuthStateChangesUseCase: mockGetAuthStateChangesUseCase,
      );

      // Act - Emit authenticated state
      authStateController.add(true);
      // Allow the stream event to be processed
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Assert
      expect(authRouterNotifier.isAuthenticated, isTrue);

      // Act - Emit unauthenticated state
      authStateController.add(false);
      // Allow the stream event to be processed
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Assert
      expect(authRouterNotifier.isAuthenticated, isFalse);

      // Clean up
      authRouterNotifier.dispose();
    });

    test('should notify listeners when authentication state changes', () async {
      // Create a separate controller for this test
      final testController = StreamController<bool>.broadcast();
      when(mockGetAuthStateChangesUseCase.execute())
          .thenAnswer((_) => testController.stream);

      // Create the notifier with the mock use case
      final authRouterNotifier = AuthRouterNotifier(
        getAuthStateChangesUseCase: mockGetAuthStateChangesUseCase,
      );

      // Wait for initialization to complete
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Verify initial state
      expect(authRouterNotifier.isAuthenticated, isFalse);

      // Setup a counter to track notifications
      var notificationCount = 0;

      // Add listener that increments the counter when called
      authRouterNotifier.addListener(() {
        notificationCount++;
      });

      // Reset the counter
      notificationCount = 0;

      // Act - Emit authenticated state
      testController.add(true);
      // Allow the stream event to be processed
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Assert - Verify notification occurred
      expect(notificationCount, greaterThan(0));
      expect(authRouterNotifier.isAuthenticated, isTrue);

      // Store the current count

      // Act - Emit the same state
      testController.add(true);
      // Allow the stream event to be processed
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Store the count after emitting the same state
      final countAfterSameState = notificationCount;

      // Act - Emit different state
      testController.add(false);
      // Allow the stream event to be processed
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Assert - Verify notification occurred for the state change
      expect(notificationCount, greaterThan(countAfterSameState));
      expect(authRouterNotifier.isAuthenticated, isFalse);

      // Clean up
      await testController.close();
      authRouterNotifier.dispose();
    });

    test('should handle initialization errors gracefully', () async {
      // Create a mock that throws an exception when execute is called
      final errorMockUseCase = MockGetAuthStateChangesUseCase();
      when(errorMockUseCase.execute()).thenThrow(Exception('Test error'));

      // Create a notifier with the error-throwing mock
      final authRouterNotifier = AuthRouterNotifier(
        getAuthStateChangesUseCase: errorMockUseCase,
      );

      // Verify the state is set to unauthenticated after error
      expect(authRouterNotifier.isAuthenticated, isFalse);

      // Clean up
      authRouterNotifier.dispose();
    });

    test('should cancel subscription when disposed', () async {
      // Create a separate controller for this test
      final testController = StreamController<bool>.broadcast();
      when(mockGetAuthStateChangesUseCase.execute())
          .thenAnswer((_) => testController.stream);

      // Create the notifier with the mock use case
      final authRouterNotifier = AuthRouterNotifier(
        getAuthStateChangesUseCase: mockGetAuthStateChangesUseCase,
      );

      // Wait for initialization to complete
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Setup a flag to track if notification occurred
      var notificationOccurred = false;

      // Add listener that sets the flag when called
      authRouterNotifier.addListener(() {
        notificationOccurred = true;
      });

      // Emit initial state and verify listener is called
      testController.add(true);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(notificationOccurred, isTrue);

      // Reset the flag
      notificationOccurred = false;

      // Act - Dispose the notifier
      authRouterNotifier.dispose();

      // Emit a new state after disposal (should not trigger listener)
      testController.add(false);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Assert - No notification should have occurred
      expect(notificationOccurred, isFalse);

      // Clean up
      await testController.close();
    });
  });

  group('authRouterNotifierProvider', () {
    test('should create AuthRouterNotifier with auth state changes use case',
        () {
      // Create a ProviderContainer with overrides for testing
      final container = ProviderContainer(
        overrides: [
          // Override the use case provider with our mock
          getAuthStateChangesUseCaseProvider.overrideWithValue(
            MockGetAuthStateChangesUseCase(),
          ),
        ],
      );

      // Read the provider to trigger its creation
      final authRouterNotifier = container.read(authRouterNotifierProvider);

      // Assert
      expect(authRouterNotifier, isA<AuthRouterNotifier>());
      expect(authRouterNotifier.isAuthenticated, isFalse);

      // Clean up
      container.dispose();
    });
  });
}
