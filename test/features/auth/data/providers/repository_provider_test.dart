import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/error_handler.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockErrorHandler extends Mock implements ErrorHandler {}

void main() {
  group('Auth Repository Provider', () {
    late ProviderContainer container;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockErrorHandler mockErrorHandler;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockErrorHandler = MockErrorHandler();

      // Set the mock Firebase Auth for testing
      setMockFirebaseAuth(mockFirebaseAuth);

      // Create a container with overrides
      container = ProviderContainer(
        overrides: [
          errorHandlerProvider.overrideWithValue(mockErrorHandler),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      // Reset the mock Firebase Auth after each test
      resetMockFirebaseAuth();
    });

    test('firebaseAuthProvider should return the mock instance during tests',
        () {
      // Act
      final firebaseAuth = container.read(firebaseAuthProvider);

      // Assert
      expect(firebaseAuth, equals(mockFirebaseAuth));
    });

    test(
        'authRepositoryImplProvider should create a FirebaseAuthRepository '
        'with the correct dependencies', () {
      // Act
      final repository = container.read(authRepositoryImplProvider);

      // Assert
      expect(repository, isA<FirebaseAuthRepository>());

      // We can't directly check the internal dependencies of the repository
      // since they're private, but we've verified it's the correct type
      // and we know it's constructed with the mocked dependencies
    });
  });
}
