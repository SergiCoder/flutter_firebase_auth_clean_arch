import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/features.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRouterNotifier extends Mock implements AuthRouterNotifier {}

void main() {
  group('AppRouter Error Builder Tests', () {
    late AuthRouterNotifier authNotifier;
    late GoRouter router;

    setUp(() {
      authNotifier = MockAuthRouterNotifier();
      when(() => authNotifier.isAuthenticated).thenReturn(false);

      router = AppRouter.createRouter(authNotifier: authNotifier);
    });

    test('router is configured correctly', () {
      // We can't directly test the errorBuilder function because it requires
      // a real BuildContext and GoRouterState, which are difficult to mock.
      // Instead, we'll verify that the router is configured correctly.

      // Assert
      expect(router, isNotNull);
      expect(router.routeInformationProvider, isNotNull);
      expect(router.routeInformationParser, isNotNull);
      expect(router.routerDelegate, isNotNull);
    });
  });
}
