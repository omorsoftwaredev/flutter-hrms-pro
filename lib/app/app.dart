/// ===============================================================
/// Flutter HRMS Pro
///
/// App
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';

class HrmsApp extends ConsumerWidget {
  const HrmsApp({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    // ===========================================================
    // CURRENT THEME
    // ===========================================================

    final themeMode =
    ref.watch(themeModeProvider);

    // ===========================================================
    // APP
    // ===========================================================

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      title: 'HRMS Pro',

      // =========================================================
      // LIGHT THEME
      // =========================================================

      theme: AppTheme.light,

      // =========================================================
      // DARK THEME
      // =========================================================

      darkTheme: AppTheme.dark,

      // =========================================================
      // THEME MODE
      // =========================================================

      themeMode: themeMode,

      // =========================================================
      // ROUTER
      // =========================================================

      routerConfig:
      AppRouter.router,
    );
  }
}