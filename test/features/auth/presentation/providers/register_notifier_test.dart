import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_notifier_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('RegisterNotifier', () {
    late MockAuthRepository mockAuthRepository;
    late RegisterNotifier registerNotifier;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      registerNotifier = RegisterNotifier(authRepository: mockAuthRepository);
    });

    test('initial state is RegisterInitial', () {
      expect(registerNotifier.state, isA<RegisterInitial>());
    });

    group('createUserWithEmailAndPassword', () {
      const email = 'test@example.com';
      const password = 'password123';

      test('emits loading then success states on successful registration',
          () async {
        // Arrange
        when(
          mockAuthRepository.createUserWithEmailAndPassword(
            email,
            password,
          ),
        ).thenAnswer((_) async {});

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockAuthRepository.createUserWithEmailAndPassword(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterSuccess>());
      });

      test('emits loading then error states on failed registration', () async {
        // Arrange
        const errorMessage = 'Registration failed';
        when(
          mockAuthRepository.createUserWithEmailAndPassword(
            email,
            password,
          ),
        ).thenThrow(errorMessage);

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(
          mockAuthRepository.createUserWithEmailAndPassword(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterError>());
        expect((registerNotifier.state as RegisterError).message, errorMessage);
      });

      test('handles different error types correctly', () async {
        // Arrange
        final exception = Exception('Custom exception');
        when(
          mockAuthRepository.createUserWithEmailAndPassword(
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
          mockAuthRepository.createUserWithEmailAndPassword(
            email,
            password,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterError>());
        expect(
          (registerNotifier.state as RegisterError).message,
          exception.toString(),
        );
      });
    });

    test('reset changes state to RegisterInitial', () {
      // Arrange - put the notifier in an error state
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
      expect(error.hashCode, equals('Error message'.hashCode));
    });
  });
}
