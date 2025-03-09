import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_router_notifier.dart';

/// A provider that makes the [AuthRouterNotifier] available to the widget tree
class AuthNotifierProvider extends InheritedNotifier<AuthRouterNotifier> {
  /// Creates a new [AuthNotifierProvider] with the given notifier
  const AuthNotifierProvider({
    required AuthRouterNotifier super.notifier,
    required super.child,
    super.key,
  });

  /// Returns the [AuthRouterNotifier] from the closest [AuthNotifierProvider]
  /// ancestor
  static AuthRouterNotifier of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AuthNotifierProvider>();
    if (provider == null || provider.notifier == null) {
      throw Exception('AuthNotifierProvider not found in the widget tree');
    }
    return provider.notifier!;
  }
}
