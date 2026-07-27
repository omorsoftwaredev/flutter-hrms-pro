import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import 'app_routes.dart';

class HrmsApp extends ConsumerWidget {
  const HrmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      themeModeProvider,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      darkTheme: AppTheme.dark,

      themeMode: themeMode,

      routerConfig: appRouter,
    );
  }
}