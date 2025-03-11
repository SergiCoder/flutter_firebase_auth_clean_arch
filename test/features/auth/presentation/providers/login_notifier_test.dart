import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_notifier_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('LoginNotifier', () {
    late MockAuthRepository mockAuthRepository;
    late LoginNotifier loginNotifier;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      loginNotifier = LoginNotifier(authRepository: mockAuthRepository);
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

        when(
          mockAuthRepository.signInWithEmailAndPassword(
            email,
            password,
          ),
        ).thenAnswer((_) async {});

        // Act
        await loginNotifier.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockAuthRepository.signInWithEmailAndPassword(
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
          mockAuthRepository.signInWithEmailAndPassword(
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
          mockAuthRepository.signInWithEmailAndPassword(
            email,
            password,
          ),
        ).called(1);
        expect(loginNotifier.state, isA<LoginError>());
        expect((loginNotifier.state as LoginError).message,
            contains(errorMessage));
      });

      test('handles empty email or password with error from repository',
          () async {
        // Arrange
        const email = '';
        const password = '';
        const errorMessage = 'Email and password cannot be empty';

        when(
          mockAuthRepository.signInWithEmailAndPassword(
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
          mockAuthRepository.signInWithEmailAndPassword(
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
      loginNotifier.state = const LoginError('Some error');

      // Act
      loginNotifier.reset();

      // Assert
      expect(loginNotifier.state, isA<LoginInitial>());
    });
  });
}
