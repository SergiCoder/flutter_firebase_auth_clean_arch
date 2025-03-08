import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/locale_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_router.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget
class MyApp extends StatelessWidget {
  /// Creates a new [MyApp] widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = LocaleProvider();

    final router = AppRouter.createRouter(
      localeProvider: localeProvider,
    );
    return AnimatedBuilder(
      animation: localeProvider,
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // Localization setup
          localizationsDelegates: AppLocalization.localizationDelegates,
          supportedLocales: AppLocalization.supportedLocales,
          locale: localeProvider.locale,
          // Router configuration
          routerConfig: router,
        );
      },
    );
  }
}
