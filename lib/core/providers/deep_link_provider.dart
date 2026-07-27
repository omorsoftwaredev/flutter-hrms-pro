import 'package:flutter/foundation.dart';

import '../../app/app_routes.dart';
import '../services/deep_link_service.dart';

class DeepLinkProvider {
  static Future<void> initialize() async {
    await DeepLinkService.initialize((uri) {
      debugPrint('Deep Link Received: $uri');

      if (uri.scheme == 'hrmspro' &&
          uri.host == 'reset-password') {
        debugPrint('Navigating to Update Password Page...');
        appRouter.go('/update-password');
      }
    });
  }

  static void dispose() {
    DeepLinkService.dispose();
  }
}