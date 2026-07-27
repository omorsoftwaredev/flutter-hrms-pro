import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

class DeepLinkService {
  DeepLinkService._();

  static final AppLinks _appLinks = AppLinks();

  static StreamSubscription<Uri>? _subscription;

  static Future<void> initialize(
      Function(Uri uri) onLink,
      ) async {
    // Cold Start
    final initialUri = await _appLinks.getInitialLink();

    debugPrint('Initial Deep Link: $initialUri');

    if (initialUri != null) {
      onLink(initialUri);
    }

    // Running App
    _subscription = _appLinks.uriLinkStream.listen(
          (uri) {
        debugPrint('Stream Deep Link: $uri');
        onLink(uri);
      },
      onError: (error) {
        debugPrint('Deep Link Error: $error');
      },
    );
  }

  static void dispose() {
    _subscription?.cancel();
  }
}