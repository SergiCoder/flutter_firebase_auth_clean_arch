import 'package:flutter_firebase_auth_clean_arch/core/url_strategy/default_url_strategy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DefaultUrlStrategy', () {
    test('usePathUrlStrategy should not throw any exceptions', () {
      // Act & Assert
      expect(usePathUrlStrategy, returnsNormally);
    });
  });
}
