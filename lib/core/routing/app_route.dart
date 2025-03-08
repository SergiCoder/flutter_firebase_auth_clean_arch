import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Defines all application routes as an enum
enum AppRoute {
  /// The splash screen
  splash('/splash'),

  /// The home screen
  home('/'),

  /// The login screen
  login('/login'),

  /// The register screen
  register('/register');

  /// Creates a new [AppRoute] with the given path
  const AppRoute(this.path);

  /// The path for this route
  final String path;

  /// Returns the name of this route for use with GoRouter
  String get name => toString().split('.').last;
}

/// Extension methods for GoRouter navigation with AppRoute
extension GoRouterExtension on BuildContext {
  /// Navigate to the given route
  void goRoute(AppRoute route) => go(route.path);

  /// Push the given route onto the navigation stack
  void pushRoute(AppRoute route) => push(route.path);
}
