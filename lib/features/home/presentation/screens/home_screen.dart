import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/features.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The home screen of the application
class HomeScreen extends HookConsumerWidget {
  /// Creates a new [HomeScreen] widget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    // Initialize the home screen on first build
    useEffect(
      () {
        // Skip initialization in tests to avoid timer issues
        if (!kDebugMode || !_isInTest()) {
          // Use a post-frame callback to avoid modifying provider during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              ref.read(homeProvider.notifier).initialize();
            }
          });
        }
        return null;
      },
      const [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [
          LanguageSelectorWidget(),
        ],
      ),
      body: _buildBody(context, ref, homeState),
    );
  }

  /// Checks if the code is running in a test environment
  bool _isInTest() {
    return Zone.current['inTest'] == true;
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, HomeState state) {
    if (state is HomeLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is HomeError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(state.message),
            ElevatedButton(
              onPressed: () {
                ref.read(homeProvider.notifier).signOut();
                if (context.mounted) {
                  context.goRoute(AppRoute.login);
                }
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      );
    }

    if (state is HomeUnauthenticated) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(AppLocalization.of(context).invalidCredentials),
            ElevatedButton(
              onPressed: () {
                if (context.mounted) {
                  context.goRoute(AppRoute.login);
                }
              },
              child: Text(AppLocalization.of(context).loginButton),
            ),
          ],
        ),
      );
    }

    if (state is HomeLoaded) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Welcome, ${state.email}!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(homeProvider.notifier).signOut();
                  if (context.mounted) {
                    context.goRoute(AppRoute.login);
                  }
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      );
    }

    // Default placeholder state
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
