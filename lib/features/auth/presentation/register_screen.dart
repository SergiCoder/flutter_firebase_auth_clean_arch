import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';

/// The register screen of the application
class RegisterScreen extends StatelessWidget {
  /// Creates a new [RegisterScreen] widget
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).registerTitle),
      ),
      body: const Placeholder(),
    );
  }
}
