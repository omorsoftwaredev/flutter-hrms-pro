/// ===============================================================
/// Flutter HRMS Pro
///
/// App
///
/// Version : 0.8.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';

class HrmsApp extends ConsumerWidget {
  const HrmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      title: 'HRMS Pro',

      theme: AppTheme.light,

      // পরে Dark Theme তৈরি হলে এটা পরিবর্তন করবে
      darkTheme: AppTheme.light,

      themeMode: themeMode,

      routerConfig: AppRouter.router,
    );
  }
}