import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';

/// The home screen of the application
class HomeScreen extends StatelessWidget {
  /// Creates a new [HomeScreen] widget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).homeTitle),
      ),
      body: const Placeholder(),
    );
  }
}
