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
        // Use a post-frame callback to avoid modifying provider during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ref.read(homeProvider.notifier).initialize();
          }
        });
        return null;
      },
      const [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).homeTitle),
      ),
      body: _buildBody(context, ref, homeState),
    );
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
                ref.read(authRepositoryProvider).signOut();
                if (context.mounted) {
                  context.goRoute(AppRoute.login);
                }
              },
              child: Text(AppLocalization.of(context).logoutButton),
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
                AppLocalization.of(context).welcomeMessage(state.email),
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(authRepositoryProvider).signOut();
                  if (context.mounted) {
                    context.goRoute(AppRoute.login);
                  }
                },
                child: Text(AppLocalization.of(context).logoutButton),
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
