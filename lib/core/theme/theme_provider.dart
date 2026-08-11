/// ===============================================================
/// Flutter HRMS Pro
///
/// Theme Provider
///
/// Version : 1.1.0
///
/// Features:
/// - Light Theme
/// - Dark Theme
/// - System Theme
/// - Persistent Theme Selection
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ===============================================================
// STORAGE KEY
// ===============================================================

const String _themeModeKey = 'hrms_theme_mode';


// ===============================================================
// THEME MODE PROVIDER
// ===============================================================

final themeModeProvider =
StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
      (ref) {
    return ThemeModeNotifier();
  },
);


// ===============================================================
// THEME MODE NOTIFIER
// ===============================================================

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier()
      : super(ThemeMode.light) {
    _loadTheme();
  }


  // =============================================================
  // LOAD SAVED THEME
  // =============================================================

  Future<void> _loadTheme() async {
    try {
      final preferences =
      await SharedPreferences.getInstance();

      final savedTheme =
      preferences.getString(
        _themeModeKey,
      );

      if (savedTheme == null) {
        return;
      }

      state = _themeModeFromString(
        savedTheme,
      );
    } catch (_) {
      state = ThemeMode.light;
    }
  }


  // =============================================================
  // CHANGE THEME
  // =============================================================

  Future<void> setTheme(
      ThemeMode mode,
      ) async {
    // -----------------------------------------------------------
    // Update UI immediately
    // -----------------------------------------------------------

    state = mode;

    // -----------------------------------------------------------
    // Save selection
    // -----------------------------------------------------------

    try {
      final preferences =
      await SharedPreferences.getInstance();

      await preferences.setString(
        _themeModeKey,
        _themeModeToString(mode),
      );
    } catch (_) {
      // Theme already changed in memory.
      // Storage failure should not break the application.
    }
  }


  // =============================================================
  // THEME MODE -> STRING
  // =============================================================

  String _themeModeToString(
      ThemeMode mode,
      ) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';

      case ThemeMode.dark:
        return 'dark';

      case ThemeMode.system:
        return 'system';
    }
  }


  // =============================================================
  // STRING -> THEME MODE
  // =============================================================

  ThemeMode _themeModeFromString(
      String value,
      ) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;

      case 'system':
        return ThemeMode.system;

      case 'light':
      default:
        return ThemeMode.light;
    }
  }
}