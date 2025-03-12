import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class TestAuthRepository implements AuthRepository {
  bool signInCalled = false;
  String? emailPassed;
  String? passwordPassed;
  Exception? exceptionToThrow;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    signInCalled = true;
    emailPassed = email;
    passwordPassed = password;

    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isAuthenticated() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }

  @override
  Stream<bool> get authStateChanges => throw UnimplementedError();
}

void main() {
  group('SignInWithEmailAndPasswordUseCase', () {
    late TestAuthRepository testAuthRepository;
    late SignInWithEmailAndPasswordUseCase useCase;

    setUp(() {
      testAuthRepository = TestAuthRepository();
      useCase = SignInWithEmailAndPasswordUseCase(
        authRepository: testAuthRepository,
      );
    });

    test('should call signInWithEmailAndPassword on the repository', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      await useCase.execute(email, password);

      // Assert
      expect(testAuthRepository.signInCalled, isTrue);
      expect(testAuthRepository.emailPassed, equals(email));
      expect(testAuthRepository.passwordPassed, equals(password));
    });

    test('should propagate exceptions from the repository', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final exception = Exception('Authentication failed');

      testAuthRepository.exceptionToThrow = exception;

      // Act & Assert
      expect(
        () => useCase.execute(email, password),
        throwsA(equals(exception)),
      );
    });
  });
}
