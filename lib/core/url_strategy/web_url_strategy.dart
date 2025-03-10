// This file contains the web-specific URL strategy handling.

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Use the path URL strategy for web.
void usePathUrlStrategy() {
  setUrlStrategy(PathUrlStrategy());
}
