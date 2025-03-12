import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_form_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('LoginFormNotifier', () {
    late LoginFormNotifier notifier;

    setUp(() {
      notifier = LoginFormNotifier();
    });

    test('initial state is email field', () {
      // Assert
      expect(notifier.state, equals(LoginFormField.email));
    });

    test('focusEmail sets state to email field', () {
      // Arrange
      notifier.state = LoginFormField.password;

      // Act
      notifier.focusEmail();

      // Assert
      expect(notifier.state, equals(LoginFormField.email));
    });

    test('focusPassword sets state to password field', () {
      // Arrange
      notifier.state = LoginFormField.email;

      // Act
      notifier.focusPassword();

      // Assert
      expect(notifier.state, equals(LoginFormField.password));
    });

    test('submitForm sets state to none', () {
      // Arrange
      notifier.state = LoginFormField.password;

      // Act
      notifier.submitForm();

      // Assert
      expect(notifier.state, equals(LoginFormField.none));
    });
  });

  group('loginFormProvider', () {
    test('provides a LoginFormNotifier', () {
      // Arrange
      final container = ProviderContainer();

      // Act
      final provider = container.read(loginFormProvider);

      // Assert
      expect(provider, isA<LoginFormField>());
      expect(provider, equals(LoginFormField.email));

      // Clean up
      container.dispose();
    });

    test('notifier methods update state correctly', () {
      // Arrange
      final container = ProviderContainer();
      final notifier = container.read(loginFormProvider.notifier);

      // Act & Assert - Test each method
      notifier.focusPassword();
      expect(
          container.read(loginFormProvider), equals(LoginFormField.password));

      notifier.focusEmail();
      expect(container.read(loginFormProvider), equals(LoginFormField.email));

      notifier.submitForm();
      expect(container.read(loginFormProvider), equals(LoginFormField.none));

      // Clean up
      container.dispose();
    });
  });
}
