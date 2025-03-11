# Router Testing Utilities

This directory contains mock implementations and utilities for testing routing functionality in the application.

## Available Mocks

### MockGoRouter

A mock implementation of `GoRouter` that can be used in tests to verify navigation behavior without requiring a full router setup.

```dart
// Create a mock router
final mockRouter = MockGoRouter();

// Use the mock router in tests
mockRouter.go('/home');
expect(mockRouter.location, equals('/home'));
verify(mockRouter.go('/home', extra: null)).called(1);
```

### MockAuthRouterNotifier

A mock implementation of `AuthRouterNotifier` that can be used to simulate different authentication states in tests.

```dart
// Create a mock auth notifier with initial state
final mockAuthNotifier = MockAuthRouterNotifier(isAuthenticated: false);

// Change authentication state
mockAuthNotifier.isAuthenticated = true;

// Use in tests
expect(mockAuthNotifier.isAuthenticated, isTrue);
```

## Testing AppRouter

To test the `AppRouter` with the mock implementations:

```dart
void main() {
  group('AppRouter', () {
    late MockAuthRouterNotifier authNotifier;
    late GoRouter router;

    setUp(() {
      authNotifier = MockAuthRouterNotifier();
      router = AppRouter.createRouter(authNotifier: authNotifier);
    });

    test('should create router with correct configuration', () {
      expect(router, isNotNull);
      expect(router.routerDelegate, isNotNull);
      expect(router.routeInformationParser, isNotNull);
    });
    
    test('should have routes for all AppRoute values', () {
      // Check that there's a route for each AppRoute value
      for (final appRoute in AppRoute.values) {
        // Try to navigate to each route and verify no exceptions are thrown
        expect(() => router.go(appRoute.path), returnsNormally);
      }
    });
  });
}
```

## Testing Widget Navigation

To test navigation in widgets:

```dart
testWidgets('should navigate to home when button is pressed', (tester) async {
  // Create a mock router
  final mockRouter = MockGoRouter();
  
  // Build widget with the mock router
  await tester.pumpWidget(
    MaterialApp(
      home: MockGoRouterProvider(
        router: mockRouter,
        child: YourWidget(),
      ),
    ),
  );
  
  // Trigger navigation
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  
  // Verify navigation occurred
  verify(mockRouter.go('/home', extra: null)).called(1);
});
```

## MockGoRouterProvider

For widget testing, you can create a simple provider widget:

```dart
class MockGoRouterProvider extends StatelessWidget {
  const MockGoRouterProvider({
    required this.router,
    required this.child,
    super.key,
  });

  final MockGoRouter router;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InheritedGoRouter(
      goRouter: router,
      child: child,
    );
  }
}
```

## Notes

- The mock implementations are designed to work with go_router version 14.8.1
- When testing redirection logic, you may need to test the router's behavior directly
- For more complex testing scenarios, consider using the real `GoRouter` with mock dependencies 