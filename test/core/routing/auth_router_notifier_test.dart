import 'dart:async';

import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_router_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mock for AuthRepository
@GenerateMocks([AuthRepository])
import 'auth_router_notifier_test.mocks.dart';

void main() {
  group('AuthRouterNotifier', () {
    late MockAuthRepository mockAuthRepository;
    late StreamController<bool> authStateController;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authStateController = StreamController<bool>.broadcast();

      // Setup the mock repository to return our controlled stream
      when(mockAuthRepository.authStateChanges)
          .thenAnswer((_) => authStateController.stream);
    });

    tearDown(() {
      // Clean up resources
      authStateController.close();
    });

    test('should initialize with unauthenticated state by default', () {
      // Create the notifier with the mock repository
      final authRouterNotifier = AuthRouterNotifier(
        authRepository: mockAuthRepository,
      );

      // Assert
      expect(authRouterNotifier.isAuthenticated, isFalse);

      // Clean up
      authRouterNotifier.dispose();
    });

    test('should update authentication state when stream emits new value',
        () async {
      // Create the notifier with the mock repository
      final authRouterNotifier = AuthRouterNotifier(
        authRepository: mockAuthRepository,
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
      when(mockAuthRepository.authStateChanges)
          .thenAnswer((_) => testController.stream);

      // Create the notifier with the mock repository
      final authRouterNotifier = AuthRouterNotifier(
        authRepository: mockAuthRepository,
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
      // Create a mock that throws an exception when authStateChanges is
      // accessed
      final errorMockRepository = MockAuthRepository();
      when(errorMockRepository.authStateChanges)
          .thenThrow(Exception('Test error'));

      // Create a notifier with the error-throwing mock
      final authRouterNotifier = AuthRouterNotifier(
        authRepository: errorMockRepository,
      );

      // Verify the state is set to unauthenticated after error
      expect(authRouterNotifier.isAuthenticated, isFalse);

      // Clean up
      authRouterNotifier.dispose();
    });

    test('should cancel subscription when disposed', () async {
      // Create a separate controller for this test
      final testController = StreamController<bool>.broadcast();
      when(mockAuthRepository.authStateChanges)
          .thenAnswer((_) => testController.stream);

      // Create the notifier with the mock repository
      final authRouterNotifier = AuthRouterNotifier(
        authRepository: mockAuthRepository,
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
    test('should create AuthRouterNotifier with auth repository', () {
      // Create a ProviderContainer with overrides for testing
      final container = ProviderContainer(
        overrides: [
          // Override the auth repository provider with our mock
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
      );

      // Read the provider to trigger its creation
      final authRouterNotifier = container.read(authRouterNotifierProvider);

      // Assert
      expect(authRouterNotifier, isA<AuthRouterNotifier>());
      expect(authRouterNotifier.isAuthenticated, isFalse);

      // Clean up
      // This test would require a ProviderContainer from Riverpod
      // which is beyond the scope of this simple test
      // In a real test, you would use ProviderContainer to test the provider
      expect(authRouterNotifierProvider, isNotNull);
    });
  });
}
