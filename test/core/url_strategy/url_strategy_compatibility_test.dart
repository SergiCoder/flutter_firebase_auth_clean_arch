import 'package:flutter_firebase_auth_clean_arch/core/url_strategy/default_url_strategy.dart'
    as default_strategy;
import 'package:flutter_test/flutter_test.dart';

import 'mock_web_url_strategy.dart' as mock_web_strategy;

void main() {
  group('URL Strategy Compatibility', () {
    test('Both implementations have the same function signature', () {
      // Get the function references
      const defaultFunction = default_strategy.usePathUrlStrategy;
      const mockWebFunction = mock_web_strategy.usePathUrlStrategy;

      // Verify both functions can be called without parameters
      expect(defaultFunction, returnsNormally);
      expect(mockWebFunction, returnsNormally);

      // Verify they have the same function type
      expect(defaultFunction.runtimeType, equals(mockWebFunction.runtimeType));
    });
  });
}
