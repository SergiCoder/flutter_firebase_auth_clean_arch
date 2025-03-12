import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/error_handler.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mock classes
@GenerateMocks([FirebaseAuth, UserCredential, User])
import 'firebase_auth_repository_test.mocks.dart';

// Simple mock for ErrorHandler
class MockErrorHandler implements ErrorHandler {
  const MockErrorHandler();

  @override
  AppException handleError(dynamic error) => const UnexpectedException();

  @override
  AppException handleFirebaseAuthError(FirebaseAuthException error) =>
      const UnexpectedException();

  @override
  AppException handleFirebaseError(FirebaseException error) =>
      const UnexpectedException();
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late ErrorHandler mockErrorHandler;
  late FirebaseAuthRepository repository;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockErrorHandler = const MockErrorHandler();
    repository = FirebaseAuthRepository(
      firebaseAuth: mockFirebaseAuth,
      errorHandler: mockErrorHandler,
    );
    mockUser = MockUser();
  });

  group('FirebaseAuthRepository', () {
    test('isAuthenticated returns true when user is not null', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, isTrue);
      verify(mockFirebaseAuth.currentUser).called(1);
    });

    test('isAuthenticated returns false when user is null', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, isFalse);
      verify(mockFirebaseAuth.currentUser).called(1);
    });

    test('signInWithEmailAndPassword calls Firebase Auth', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      // Act
      await repository.signInWithEmailAndPassword(
        'test@example.com',
        'password',
      );

      // Assert
      verify(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        ),
      ).called(1);
    });

    test('createUserWithEmailAndPassword calls Firebase Auth', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      // Act
      await repository.createUserWithEmailAndPassword(
        'test@example.com',
        'password',
      );

      // Assert
      verify(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        ),
      ).called(1);
    });

    test('signOut calls Firebase Auth', () async {
      // Arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      // Act
      await repository.signOut();

      // Assert
      verify(mockFirebaseAuth.signOut()).called(1);
    });

    test('authStateChanges emits correct values', () async {
      // Arrange
      final mockAuthStateChanges = Stream<User?>.fromIterable([mockUser, null]);
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => mockAuthStateChanges);

      // Act & Assert
      expect(
        repository.authStateChanges,
        emitsInOrder([true, false]),
      );
    });
  });
}
