import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_form_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('RegisterFormNotifier', () {
    late RegisterFormNotifier notifier;

    setUp(() {
      notifier = RegisterFormNotifier();
    });

    test('initial state is email field', () {
      // Assert
      expect(notifier.state, equals(RegisterFormField.email));
    });

    test('focusEmail sets state to email field', () {
      // Arrange
      notifier.state = RegisterFormField.password;

      // Act
      notifier.focusEmail();

      // Assert
      expect(notifier.state, equals(RegisterFormField.email));
    });

    test('focusPassword sets state to password field', () {
      // Arrange
      notifier.state = RegisterFormField.email;

      // Act
      notifier.focusPassword();

      // Assert
      expect(notifier.state, equals(RegisterFormField.password));
    });

    test('focusConfirmPassword sets state to confirmPassword field', () {
      // Arrange
      notifier.state = RegisterFormField.password;

      // Act
      notifier.focusConfirmPassword();

      // Assert
      expect(notifier.state, equals(RegisterFormField.confirmPassword));
    });

    test('submitForm sets state to none', () {
      // Arrange
      notifier.state = RegisterFormField.confirmPassword;

      // Act
      notifier.submitForm();

      // Assert
      expect(notifier.state, equals(RegisterFormField.none));
    });
  });

  group('registerFormProvider', () {
    test('provides a RegisterFormNotifier', () {
      // Arrange
      final container = ProviderContainer();

      // Act
      final provider = container.read(registerFormProvider);

      // Assert
      expect(provider, isA<RegisterFormField>());
      expect(provider, equals(RegisterFormField.email));

      // Clean up
      container.dispose();
    });

    test('notifier methods update state correctly', () {
      // Arrange
      final container = ProviderContainer();
      final notifier = container.read(registerFormProvider.notifier);

      // Act & Assert - Test each method
      notifier.focusPassword();
      expect(container.read(registerFormProvider),
          equals(RegisterFormField.password));

      notifier.focusConfirmPassword();
      expect(container.read(registerFormProvider),
          equals(RegisterFormField.confirmPassword));

      notifier.focusEmail();
      expect(container.read(registerFormProvider),
          equals(RegisterFormField.email));

      notifier.submitForm();
      expect(
          container.read(registerFormProvider), equals(RegisterFormField.none));

      // Clean up
      container.dispose();
    });
  });
}
