import 'package:flutter_firebase_auth_clean_arch/core/error/error_handler.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('Error Handler Provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('errorHandlerProvider should create an ErrorHandler instance', () {
      // Act
      final errorHandler = container.read(errorHandlerProvider);

      // Assert
      expect(errorHandler, isA<ErrorHandler>());
    });
  });
}
