import 'package:flutter/foundation.dart';

import '../router/app_router.dart';
import '../router/route_paths.dart';
import '../services/deep_link_service.dart';

class DeepLinkProvider {
  DeepLinkProvider._();

  static Future<void> initialize() async {
    await DeepLinkService.initialize((uri) {
      debugPrint('Deep Link Received: $uri');

      if (uri.scheme == 'hrmspro' &&
          uri.host == 'reset-password') {
        debugPrint('Navigating to Update Password Page...');

        AppRouter.router.go(
          RoutePaths.updatePassword,
        );
      }
    });
  }

  static void dispose() {
    DeepLinkService.dispose();
  }
}