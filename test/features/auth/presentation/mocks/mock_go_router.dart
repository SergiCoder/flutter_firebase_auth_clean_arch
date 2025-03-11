import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_route.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

/// A mock implementation of [GoRouter] for testing purposes.
class MockGoRouter extends Mock implements GoRouter {
  /// The current location of the router.
  String _location = AppRoute.splash.path;

  /// Returns the current location of the router.
  String get location => _location;

  @override
  void go(String location, {Object? extra}) {
    _location = location;
    super.noSuchMethod(
      Invocation.method(#go, [location], {#extra: extra}),
      returnValue: null,
    );
  }

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    _location = location;
    return Future<T?>.value(null);
  }

  @override
  void pop<T extends Object?>([T? result]) {
    super.noSuchMethod(
      Invocation.method(#pop, result == null ? [] : [result]),
      returnValue: null,
    );
  }

  /// Resets the mock to its initial state.
  void reset() {
    _location = AppRoute.splash.path;
    clearInteractions(this);
  }
}

/// A widget that provides a [MockGoRouter] to its descendants.
class MockGoRouterProvider extends StatelessWidget {
  /// Creates a new [MockGoRouterProvider].
  const MockGoRouterProvider({
    required this.router,
    required this.child,
    super.key,
  });

  /// The mock router to provide to descendants.
  final MockGoRouter router;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InheritedGoRouter(
      goRouter: router,
      child: child,
    );
  }
}
