import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/core/presentation/widgets/error_widget.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/routing.dart';

/// A screen to display when a route is not found or an error occurs during
/// routing.
class ErrorScreen extends StatelessWidget {
  /// Creates a new [ErrorScreen].
  const ErrorScreen({
    required this.uri,
    super.key,
  });

  /// The URI that was not found.
  final String uri;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalization.of(context);

    // Use the localized message with the URI
    final message = '${localizations.pageNotFoundMessage}\n\n$uri';

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.errorPageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ErrorDisplayWidget(
              errorMessage: message,
            ),
            ElevatedButton(
              onPressed: () => context.goRoute(AppRoute.home),
              child: Text(localizations.goBack),
            ),
          ],
        ),
      ),
    );
  }
}
