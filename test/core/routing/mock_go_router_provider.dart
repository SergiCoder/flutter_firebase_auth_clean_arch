import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'mock_go_router.dart';

/// A widget that provides a [MockGoRouter] to its descendants.
///
/// This widget makes it easy to test widgets that depend on [GoRouter]
/// by providing a mock implementation that can be verified in tests.
class MockGoRouterProvider extends StatelessWidget {
  /// Creates a new [MockGoRouterProvider].
  ///
  /// [router] The mock router to provide to descendants.
  /// [child] The widget below this widget in the tree.
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
