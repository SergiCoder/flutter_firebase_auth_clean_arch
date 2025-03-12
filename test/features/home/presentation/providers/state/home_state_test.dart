import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/providers/state/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeState', () {
    group('HomeInitial', () {
      test('props are empty', () {
        const state = HomeInitial();
        expect(state.props, []);
      });

      test('two instances are equal', () {
        const state1 = HomeInitial();
        const state2 = HomeInitial();
        expect(state1, equals(state2));
      });
    });

    group('HomeLoading', () {
      test('props are empty', () {
        const state = HomeLoading();
        expect(state.props, []);
      });

      test('two instances are equal', () {
        const state1 = HomeLoading();
        const state2 = HomeLoading();
        expect(state1, equals(state2));
      });
    });

    group('HomeLoaded', () {
      const email = 'test@example.com';

      test('props contain email', () {
        const state = HomeLoaded(email: email);
        expect(state.props, [email]);
      });

      test('two instances with same email are equal', () {
        const state1 = HomeLoaded(email: email);
        const state2 = HomeLoaded(email: email);
        expect(state1, equals(state2));
      });

      test('two instances with different emails are not equal', () {
        const state1 = HomeLoaded(email: email);
        const state2 = HomeLoaded(email: 'other@example.com');
        expect(state1, isNot(equals(state2)));
      });
    });

    group('HomeUnauthenticated', () {
      test('props are empty', () {
        const state = HomeUnauthenticated();
        expect(state.props, []);
      });

      test('two instances are equal', () {
        const state1 = HomeUnauthenticated();
        const state2 = HomeUnauthenticated();
        expect(state1, equals(state2));
      });
    });

    group('HomeError', () {
      const errorMessage = 'Test error message';

      test('props contain message', () {
        const state = HomeError(errorMessage);
        expect(state.props, [errorMessage]);
      });

      test('two instances with same message are equal', () {
        const state1 = HomeError(errorMessage);
        const state2 = HomeError(errorMessage);
        expect(state1, equals(state2));
      });

      test('two instances with different messages are not equal', () {
        const state1 = HomeError(errorMessage);
        const state2 = HomeError('Different error message');
        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
