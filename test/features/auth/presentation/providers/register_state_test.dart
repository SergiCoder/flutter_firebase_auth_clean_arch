import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/state/register_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterState', () {
    test('RegisterInitial is a RegisterState', () {
      const state = RegisterInitial();
      expect(state, isA<RegisterState>());
    });

    test('RegisterLoading is a RegisterState', () {
      const state = RegisterLoading();
      expect(state, isA<RegisterState>());
    });

    test('RegisterSuccess is a RegisterState', () {
      const state = RegisterSuccess();
      expect(state, isA<RegisterState>());
    });

    test('RegisterError is a RegisterState', () {
      const state = RegisterError('Error message');
      expect(state, isA<RegisterState>());
    });

    group('RegisterError', () {
      test('has correct message', () {
        const errorMessage = 'Error message';
        const state = RegisterError(errorMessage);
        expect(state.message, errorMessage);
      });

      test('equality works correctly', () {
        const error1 = RegisterError('Error message');
        const error2 = RegisterError('Error message');
        const error3 = RegisterError('Different message');

        expect(error1 == error2, isTrue);
        expect(error1 == error3, isFalse);
        expect(error1 == error1, isTrue);
        expect(error1 == const RegisterSuccess(), isFalse);
      });

      test('hashCode works correctly', () {
        const errorMessage = 'Error message';
        const state = RegisterError(errorMessage);
        expect(state.hashCode, isA<int>());
      });
    });
  });
}
