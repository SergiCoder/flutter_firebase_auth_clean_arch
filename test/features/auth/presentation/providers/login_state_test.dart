import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/state/login_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginState', () {
    group('LoginInitial', () {
      test('instances should be equal', () {
        const state1 = LoginInitial();
        const state2 = LoginInitial();

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('LoginLoading', () {
      test('instances should be equal', () {
        const state1 = LoginLoading();
        const state2 = LoginLoading();

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('LoginSuccess', () {
      test('instances should be equal', () {
        const state1 = LoginSuccess();
        const state2 = LoginSuccess();

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('LoginError', () {
      test('instances with same message should be equal', () {
        const errorMessage = 'Error message';
        const state1 = LoginError(errorMessage);
        const state2 = LoginError(errorMessage);

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('instances with different messages should not be equal', () {
        const state1 = LoginError('Error message 1');
        const state2 = LoginError('Error message 2');

        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('message property returns correct value', () {
        const errorMessage = 'Error message';
        const state = LoginError(errorMessage);

        expect(state.message, equals(errorMessage));
      });
    });
  });
}
