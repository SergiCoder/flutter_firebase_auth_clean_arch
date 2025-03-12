import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/create_user_with_email_and_password_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/state/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCreateUserWithEmailAndPasswordUseCase extends Mock
    implements CreateUserWithEmailAndPasswordUseCase {
  @override
  Future<void> execute(String email, String password) async {
    return super.noSuchMethod(
      Invocation.method(#execute, [email, password]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

void main() {
  group('RegisterNotifier', () {
    late MockCreateUserWithEmailAndPasswordUseCase mockCreateUserUseCase;
    late RegisterNotifier registerNotifier;

    setUp(() {
      mockCreateUserUseCase = MockCreateUserWithEmailAndPasswordUseCase();
      registerNotifier =
          RegisterNotifier(createUserUseCase: mockCreateUserUseCase);
    });

    test('initial state is RegisterInitial', () {
      expect(registerNotifier.state, isA<RegisterInitial>());
    });

    group('createUserWithEmailAndPassword', () {
      test(
          '''emits RegisterLoading and RegisterSuccess on successful registration''',
          () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterSuccess>());
      });

      test('handles InvalidCredentialsException correctly', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const errorMessage = 'Invalid email format';
        final exception = InvalidCredentialsException(message: errorMessage);

        when(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).thenThrow(exception);

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterError>());
        expect(
          (registerNotifier.state as RegisterError).message,
          equals(errorMessage),
        );
      });

      test('handles EmailAlreadyInUseException correctly', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const errorMessage = 'Email already in use';
        final exception = EmailAlreadyInUseException(message: errorMessage);

        when(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).thenThrow(exception);

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterError>());
        expect(
          (registerNotifier.state as RegisterError).message,
          equals(errorMessage),
        );
      });

      test('handles WeakPasswordException correctly', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'weak';
        const errorMessage = 'Password is too weak';
        final exception = WeakPasswordException(message: errorMessage);

        when(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).thenThrow(exception);

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterError>());
        expect(
          (registerNotifier.state as RegisterError).message,
          equals(errorMessage),
        );
      });

      test('handles AuthException correctly', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const errorMessage = 'Authentication error';
        final exception = AuthException(errorMessage);

        when(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).thenThrow(exception);

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterError>());
        expect(
          (registerNotifier.state as RegisterError).message,
          equals(errorMessage),
        );
      });

      test('handles AppException correctly', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const errorMessage = 'Application error';
        final exception = UnexpectedException(message: errorMessage);

        when(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).thenThrow(exception);

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterError>());
        expect(
          (registerNotifier.state as RegisterError).message,
          equals(errorMessage),
        );
      });

      test('handles generic Exception correctly', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const errorMessage = 'Unknown error';
        final exception = Exception(errorMessage);

        when(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).thenThrow(exception);

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterError>());
        expect(
          (registerNotifier.state as RegisterError).message,
          contains(errorMessage),
        );
      });

      test('handles empty email or password with error from use case',
          () async {
        // Arrange
        const email = '';
        const password = '';
        const errorMessage = 'Email and password cannot be empty';

        when(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).thenThrow(Exception(errorMessage));

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockCreateUserUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterError>());
        expect(
          (registerNotifier.state as RegisterError).message,
          contains(errorMessage),
        );
      });
    });

    test('reset sets state to RegisterInitial', () {
      // Arrange
      registerNotifier
        ..state = const RegisterError('Some error')

        // Act
        ..reset();

      // Assert
      expect(registerNotifier.state, isA<RegisterInitial>());
    });

    test('state equality works correctly', () {
      // Same error message
      const error1 = RegisterError('Error message');
      const error2 = RegisterError('Error message');
      expect(error1 == error2, isTrue);

      // Different error messages
      const error3 = RegisterError('Different message');
      expect(error1 == error3, isFalse);

      // Same object
      expect(error1 == error1, isTrue);

      // Different types
      const success = RegisterSuccess();
      expect(error1 == success, isFalse);
    });

    test('state hashCode works correctly', () {
      const error = RegisterError('Error message');
      // Equatable uses a different hashCode implementation
      expect(error.hashCode, isA<int>());
    });
  });
}
