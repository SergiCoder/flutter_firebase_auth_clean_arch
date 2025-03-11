import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterState', () {
    group('RegisterInitial', () {
      test('instances should be equal', () {
        const state1 = RegisterInitial();
        const state2 = RegisterInitial();

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('RegisterLoading', () {
      test('instances should be equal', () {
        const state1 = RegisterLoading();
        const state2 = RegisterLoading();

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('RegisterSuccess', () {
      test('instances should be equal', () {
        const state1 = RegisterSuccess();
        const state2 = RegisterSuccess();

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('RegisterError', () {
      test('instances with same message should be equal', () {
        const errorMessage = 'Error message';
        const state1 = RegisterError(errorMessage);
        const state2 = RegisterError(errorMessage);

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('instances with different messages should not be equal', () {
        const state1 = RegisterError('Error message 1');
        const state2 = RegisterError('Error message 2');

        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('message property returns correct value', () {
        const errorMessage = 'Error message';
        const state = RegisterError(errorMessage);

        expect(state.message, equals(errorMessage));
      });
    });
  });
}
