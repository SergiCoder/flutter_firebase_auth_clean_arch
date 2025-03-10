import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/core/presentation/widgets/error_widget.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/routing.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/notifiers/splash_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/splash_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The splash screen of the application
class SplashScreen extends HookConsumerWidget {
  /// Creates a new [SplashScreen] widget
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashState = ref.watch(splashProvider);

    // Initialize the splash screen on first build
    useEffect(
      () {
        // Use a post-frame callback to avoid modifying provider during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ref.read(splashProvider.notifier).initialize();
          }
        });
        return null;
      },
      const [],
    );

    // Handle navigation when state changes to SplashNavigate
    useEffect(
      () {
        if (splashState is SplashNavigate) {
          // Navigate to the appropriate screen based on authentication status
          // Using a microtask to avoid build-time navigation
          Future<void>.microtask(() {
            // Check if the widget is still mounted before using context
            if (!context.mounted) return;

            if (splashState.isAuthenticated) {
              // Navigate to home if authenticated
              context.goRoute(AppRoute.home);
            } else {
              // Navigate to login if not authenticated
              context.goRoute(AppRoute.login);
            }
          });
        }
        return null;
      },
      [splashState],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).appTitle),
      ),
      body: Center(
        child: _buildBody(context, splashState, ref),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SplashState state, WidgetRef ref) {
    if (state is SplashLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.lock_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const CircularProgressIndicator(),
        ],
      );
    } else if (state is SplashError) {
      return ErrorDisplayWidget(
        errorMessage: state.message,
      );
    } else {
      // Initial state or Navigate state (before navigation completes)
      return const SizedBox();
    }
  }
}
