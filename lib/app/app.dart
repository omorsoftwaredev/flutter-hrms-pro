import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'app_theme.dart';

class HrmsApp extends StatelessWidget {
  const HrmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter HRMS Pro',
      routerConfig: appRouter,
      theme: AppTheme.light,
    );
  }
}