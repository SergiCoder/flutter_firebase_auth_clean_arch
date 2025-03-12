import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/state/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSignInWithEmailAndPasswordUseCase extends Mock
    implements SignInWithEmailAndPasswordUseCase {
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
  group('LoginNotifier', () {
    late MockSignInWithEmailAndPasswordUseCase mockSignInUseCase;
    late LoginNotifier loginNotifier;

    setUp(() {
      mockSignInUseCase = MockSignInWithEmailAndPasswordUseCase();
      loginNotifier = LoginNotifier(signInUseCase: mockSignInUseCase);
    });

    test('initial state is LoginInitial', () {
      // Assert
      expect(loginNotifier.state, isA<LoginInitial>());
    });

    group('signInWithEmailAndPassword', () {
      test('emits LoginLoading and LoginSuccess on successful login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        // Act
        await loginNotifier.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockSignInUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(loginNotifier.state, isA<LoginSuccess>());
      });

      test('emits LoginLoading and LoginError on login failure', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const errorMessage = 'Invalid credentials';

        when(
          mockSignInUseCase.execute(
            email,
            password,
          ),
        ).thenThrow(Exception(errorMessage));

        // Act
        await loginNotifier.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockSignInUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(loginNotifier.state, isA<LoginError>());
        expect(
          (loginNotifier.state as LoginError).message,
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
          mockSignInUseCase.execute(
            email,
            password,
          ),
        ).thenThrow(Exception(errorMessage));

        // Act
        await loginNotifier.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockSignInUseCase.execute(
            email,
            password,
          ),
        ).called(1);
        expect(loginNotifier.state, isA<LoginError>());
        expect(
          (loginNotifier.state as LoginError).message,
          contains(errorMessage),
        );
      });
    });

    test('reset sets state to LoginInitial', () {
      // Arrange
      loginNotifier
        ..state = const LoginError('Some error')

        // Act
        ..reset();

      // Assert
      expect(loginNotifier.state, isA<LoginInitial>());
    });
  });
}
