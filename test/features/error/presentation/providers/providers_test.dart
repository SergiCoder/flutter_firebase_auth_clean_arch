import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/providers/providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Providers exports', () {
    test('errorProvider is exported correctly', () {
      // Verify that errorProvider is accessible from the providers.dart export
      expect(errorProvider, isNotNull);

      // Verify that it's a provider that provides ErrorState
      expect(errorProvider, isA<Object>());
    });

    test('ErrorState classes are exported correctly', () {
      // Verify that ErrorState classes are accessible from the providers.dart
      // export
      expect(ErrorInitial, isNotNull);
      expect(ErrorProcessing, isNotNull);
      expect(ErrorHandled, isNotNull);
      expect(ErrorFailed, isNotNull);

      // Create instances to verify they can be instantiated
      const initialState = ErrorInitial();
      const processingState = ErrorProcessing();
      const handledState = ErrorHandled();
      const failedState = ErrorFailed('Test error');

      // Verify they are all subclasses of ErrorState
      expect(initialState, isA<ErrorState>());
      expect(processingState, isA<ErrorState>());
      expect(handledState, isA<ErrorState>());
      expect(failedState, isA<ErrorState>());
    });
  });
}
