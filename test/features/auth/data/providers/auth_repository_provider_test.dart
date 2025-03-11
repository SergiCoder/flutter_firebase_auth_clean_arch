import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ProviderContainer container;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();

    container = ProviderContainer(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('FirebaseAuthProvider', () {
    test('provides the Firebase Auth instance', () {
      // Act
      final auth = container.read(firebaseAuthProvider);

      // Assert
      expect(auth, equals(mockFirebaseAuth));
    });
  });

  group('AuthRepositoryProvider', () {
    test('provides a FirebaseAuthRepository instance', () {
      // Act
      final repository = container.read(authRepositoryProvider);

      // Assert
      expect(repository, isA<FirebaseAuthRepository>());
    });

    test('provides the same instance each time', () {
      // Act
      final repository1 = container.read(authRepositoryProvider);
      final repository2 = container.read(authRepositoryProvider);

      // Assert
      expect(identical(repository1, repository2), isTrue);
    });
  });
}
