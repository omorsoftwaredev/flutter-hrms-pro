/// ===============================================================
/// Flutter HRMS Pro
///
/// Main Entry Point
///
/// Version : 0.8.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/services/supabase_service.dart';

Future<void> main() async {
  // =============================================================
  // Flutter Binding
  // =============================================================

  WidgetsFlutterBinding.ensureInitialized();

  // =============================================================
  // Environment
  // =============================================================

  await dotenv.load(fileName: '.env');

  // =============================================================
  // Supabase
  // =============================================================

  await SupabaseService.initialize();

  // =============================================================
  // Run App
  // =============================================================

  runApp(const ProviderScope(child: HrmsApp()));
}
