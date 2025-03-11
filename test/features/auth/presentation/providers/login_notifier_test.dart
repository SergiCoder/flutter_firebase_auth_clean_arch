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
      expect(loginNotifier.state, isA<LoginInitial>());
    });

    group('signInWithEmailAndPassword', () {
      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      test('emits [LoginLoading, LoginSuccess] when login succeeds', () async {
        // Arrange
        when(
          mockAuthRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).thenAnswer((_) async {});

        // Act
        await loginNotifier.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );

        // Assert
        verify(
          mockAuthRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).called(1);
        expect(loginNotifier.state, isA<LoginSuccess>());
      });

      test('emits [LoginLoading, LoginError] when login fails', () async {
        // Arrange
        const errorMessage = 'Invalid credentials';
        when(
          mockAuthRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).thenThrow(errorMessage);

        // Act
        await loginNotifier.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );

        // Assert
        verify(
          mockAuthRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).called(1);
        expect(loginNotifier.state, isA<LoginError>());
        expect((loginNotifier.state as LoginError).message, errorMessage);
      });
    });

    test('reset changes state to LoginInitial', () {
      // Arrange - put the notifier in an error state
      loginNotifier = LoginNotifier(authRepository: mockAuthRepository)
        ..state = const LoginError('Some error')

        // Act
        ..reset();

      // Assert
      expect(loginNotifier.state, isA<LoginInitial>());
    });
  });
}
