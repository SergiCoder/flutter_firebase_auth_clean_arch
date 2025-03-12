export 'di/providers.dart';
export 'error/error.dart';
export 'firebase/firebase_options.dart';
export 'localization/localization.dart';
export 'presentation/presentation.dart';
export 'routing/routing.dart';
export 'theme/app_theme.dart';
// Use conditional export to avoid web-specific code in non-web environments
export 'url_strategy/default_url_strategy.dart'
    if (dart.library.html) 'url_strategy/web_url_strategy.dart';
