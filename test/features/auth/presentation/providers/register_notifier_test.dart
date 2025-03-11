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
      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      test(
          'emits [RegisterLoading, RegisterSuccess] when registration succeeds',
          () async {
        // Arrange
        when(
          mockAuthRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).thenAnswer((_) async {});

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );

        // Assert
        verify(
          mockAuthRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterSuccess>());
      });

      test('emits [RegisterLoading, RegisterError] when registration fails',
          () async {
        // Arrange
        const errorMessage = 'Email already in use';
        when(
          mockAuthRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).thenThrow(errorMessage);

        // Act
        await registerNotifier.createUserWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );

        // Assert
        verify(
          mockAuthRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).called(1);
        expect(registerNotifier.state, isA<RegisterError>());
        expect((registerNotifier.state as RegisterError).message, errorMessage);
      });
    });

    test('reset changes state to RegisterInitial', () {
      // Arrange - put the notifier in an error state
      registerNotifier = RegisterNotifier(authRepository: mockAuthRepository)
        ..state = const RegisterError('Some error')

        // Act
        ..reset();

      // Assert
      expect(registerNotifier.state, isA<RegisterInitial>());
    });
  });
}
