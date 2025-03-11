import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_route.dart';

import 'mock_go_router.dart';

void main() {
  group('MockGoRouter', () {
    late MockGoRouter mockRouter;

    setUp(() {
      mockRouter = MockGoRouter();
    });

    test('should update location when go is called', () {
      // Arrange
      const expectedLocation = '/home';

      // Act
      mockRouter.go(expectedLocation);

      // Assert
      expect(mockRouter.location, equals(expectedLocation));
    });

    test('should update location when push is called', () {
      // Arrange
      const expectedLocation = '/login';

      // Act
      mockRouter.push(expectedLocation);

      // Assert
      expect(mockRouter.location, equals(expectedLocation));
    });

    test('should update location when replace is called', () {
      // Arrange
      const expectedLocation = '/register';

      // Act
      mockRouter.replace(expectedLocation);

      // Assert
      expect(mockRouter.location, equals(expectedLocation));
    });

    test('should call pop method', () {
      // Act
      mockRouter.pop();

      // No assertion needed - just verifying it doesn't throw
    });

    test('should reset location to splash path', () {
      // Arrange
      mockRouter.go('/home');
      expect(mockRouter.location, equals('/home'));

      // Act
      mockRouter.reset();

      // Assert
      expect(mockRouter.location, equals(AppRoute.splash.path));
    });
  });

  group('createMockRouter', () {
    test('should create router with default location', () {
      // Act
      final router = createMockRouter() as MockGoRouter;

      // Assert
      expect(router, isA<MockGoRouter>());
      expect(router.location, equals(AppRoute.splash.path));
    });

    test('should create router with specified initial location', () {
      // Arrange
      const initialLocation = '/login';

      // Act
      final router =
          createMockRouter(initialLocation: initialLocation) as MockGoRouter;

      // Assert
      expect(router, isA<MockGoRouter>());
      expect(router.location, equals(initialLocation));
    });
  });
}
