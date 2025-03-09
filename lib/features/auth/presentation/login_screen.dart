import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';

/// The login screen of the application
class LoginScreen extends StatelessWidget {
  /// Creates a new [LoginScreen] widget
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).loginTitle),
      ),
      body: const Placeholder(),
    );
  }
}
