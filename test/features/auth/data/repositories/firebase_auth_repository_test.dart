// ignore_for_file: must_be_immutable

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

// Custom mock for FirebaseAuthException
class MockFirebaseAuthException extends Mock implements FirebaseAuthException {
  MockFirebaseAuthException({required this.code, this.message});
  @override
  final String code;
  @override
  final String? message;
}

// Custom mock for ErrorHandler that returns specific exceptions
class TestErrorHandler implements ErrorHandler {
  const TestErrorHandler();

  @override
  AppException handleError(dynamic error) {
    return const UnexpectedException(message: 'Test general error');
  }

  @override
  AppException handleFirebaseAuthError(FirebaseAuthException error) {
    return InvalidCredentialsException(
      message: 'Test auth error',
      originalError: error,
    );
  }

  @override
  AppException handleFirebaseError(FirebaseException error) {
    return const DataException('Test firebase error');
  }
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late ErrorHandler errorHandler;
  late FirebaseAuthRepository repository;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    errorHandler = const TestErrorHandler();
    repository = FirebaseAuthRepository(
      firebaseAuth: mockFirebaseAuth,
      errorHandler: errorHandler,
    );
    mockUser = MockUser();
  });

  group('FirebaseAuthRepository', () {
    group('isAuthenticated', () {
      test('returns true when user is not null', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        final result = await repository.isAuthenticated();

        // Assert
        expect(result, isTrue);
        verify(mockFirebaseAuth.currentUser).called(1);
      });

      test('returns false when user is null', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final result = await repository.isAuthenticated();

        // Assert
        expect(result, isFalse);
        verify(mockFirebaseAuth.currentUser).called(1);
      });

      test('throws AppException when an error occurs', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenThrow(Exception('Test error'));

        // Act & Assert
        expect(
          () => repository.isAuthenticated(),
          throwsA(isA<UnexpectedException>()),
        );
        verify(mockFirebaseAuth.currentUser).called(1);
      });
    });

    group('signInWithEmailAndPassword', () {
      test('calls Firebase Auth with correct parameters', () async {
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

      test(
          'throws InvalidCredentialsException when FirebaseAuthException occurs',
          () async {
        // Arrange
        final authException = MockFirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is badly formatted.',
        );
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(authException);

        // Act & Assert
        expect(
          () => repository.signInWithEmailAndPassword(
            'test@example.com',
            'password',
          ),
          throwsA(isA<InvalidCredentialsException>()),
        );
      });

      test('throws UnexpectedException when a general error occurs', () async {
        // Arrange
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(Exception('Test error'));

        // Act & Assert
        expect(
          () => repository.signInWithEmailAndPassword(
            'test@example.com',
            'password',
          ),
          throwsA(isA<UnexpectedException>()),
        );
      });
    });

    group('createUserWithEmailAndPassword', () {
      test('calls Firebase Auth with correct parameters', () async {
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

      test(
          'throws InvalidCredentialsException when FirebaseAuthException occurs',
          () async {
        // Arrange
        final authException = MockFirebaseAuthException(
          code: 'email-already-in-use',
          message: 'The email address is already in use by another account.',
        );
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(authException);

        // Act & Assert
        expect(
          () => repository.createUserWithEmailAndPassword(
            'test@example.com',
            'password',
          ),
          throwsA(isA<InvalidCredentialsException>()),
        );
      });

      test('throws UnexpectedException when a general error occurs', () async {
        // Arrange
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(Exception('Test error'));

        // Act & Assert
        expect(
          () => repository.createUserWithEmailAndPassword(
            'test@example.com',
            'password',
          ),
          throwsA(isA<UnexpectedException>()),
        );
      });
    });

    group('signOut', () {
      test('calls Firebase Auth signOut method', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        // Act
        await repository.signOut();

        // Assert
        verify(mockFirebaseAuth.signOut()).called(1);
      });

      test('throws UnexpectedException when an error occurs', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenThrow(Exception('Test error'));

        // Act & Assert
        expect(
          () => repository.signOut(),
          throwsA(isA<UnexpectedException>()),
        );
      });
    });

    group('authStateChanges', () {
      test('emits correct values', () async {
        // Arrange
        final mockAuthStateChanges =
            Stream<User?>.fromIterable([mockUser, null]);
        when(mockFirebaseAuth.authStateChanges())
            .thenAnswer((_) => mockAuthStateChanges);

        // Act & Assert
        expect(
          repository.authStateChanges,
          emitsInOrder([true, false]),
        );
      });

      test('throws UnexpectedException when an error occurs', () {
        // Arrange
        when(mockFirebaseAuth.authStateChanges())
            .thenThrow(Exception('Test error'));

        // Act & Assert
        expect(
          () => repository.authStateChanges,
          throwsA(isA<UnexpectedException>()),
        );
      });
    });
  });
}
