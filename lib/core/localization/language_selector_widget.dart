import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/locale_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget that displays a language selector icon button
///
/// This widget shows a dropdown menu with available languages when clicked.
/// It allows users to change the application language at runtime.
class LanguageSelectorWidget extends ConsumerWidget {
  /// Creates a new [LanguageSelectorWidget]
  const LanguageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current locale provider
    final localeProvider = ref.watch(localeProviderProvider);
    final currentLocale = localeProvider.locale;

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: AppLocalization.of(context).changeLanguage,
      onSelected: localeProvider.setLocale,
      itemBuilder: (BuildContext context) {
        return AppLocalization.supportedLocales.map((Locale locale) {
          final isSelected = currentLocale.languageCode == locale.languageCode;
          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalization.getLocaleName(locale)),
                if (isSelected) const Icon(Icons.check, size: 18),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
