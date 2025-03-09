import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';

/// The splash screen of the application
class SplashScreen extends StatelessWidget {
  /// Creates a new [SplashScreen] widget
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).appTitle),
      ),
      body: const Placeholder(),
    );
  }
}
