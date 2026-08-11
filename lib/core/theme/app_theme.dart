/// ===============================================================
/// Flutter HRMS Pro
///
/// App Theme
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  // =============================================================
  // BRAND
  // =============================================================

  static const Color primaryColor = Color(0xFF2196F3);

  // =============================================================
  // LIGHT COLORS
  // =============================================================

  static const Color lightScaffold =
  Color(0xFFFFF9FF);

  static const Color lightSurface =
      Colors.white;

  static const Color lightText =
  Color(0xFF1F1F1F);

  static const Color lightSecondaryText =
  Color(0xFF6B7280);

  // =============================================================
  // DARK COLORS
  // =============================================================

  static const Color darkScaffold =
  Color(0xFF121212);

  static const Color darkSurface =
  Color(0xFF1E1E1E);

  static const Color darkText =
      Colors.white;

  static const Color darkSecondaryText =
  Color(0xFFB0B0B0);

  // =============================================================
  // LIGHT THEME
  // =============================================================

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.light,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor:
      lightScaffold,

      fontFamily: 'Roboto',

      // =========================================================
      // APP BAR
      // =========================================================

      appBarTheme: const AppBarTheme(
        backgroundColor: lightScaffold,
        foregroundColor: lightText,
        elevation: 0,
        centerTitle: false,
      ),

      // =========================================================
      // CARD
      // =========================================================

      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),

      // =========================================================
      // INPUT
      // =========================================================

      inputDecorationTheme:
      InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color: Colors.grey,
          ),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color: Colors.grey,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),

        errorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),

      // =========================================================
      // ELEVATED BUTTON
      // =========================================================

      elevatedButtonTheme:
      ElevatedButtonThemeData(
        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          primaryColor,
          foregroundColor:
          Colors.white,
          elevation: 0,
          minimumSize:
          const Size(0, 44),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(8),
          ),
        ),
      ),

      // =========================================================
      // TEXT BUTTON
      // =========================================================

      textButtonTheme:
      TextButtonThemeData(
        style:
        TextButton.styleFrom(
          foregroundColor:
          primaryColor,
        ),
      ),

      // =========================================================
      // OUTLINED BUTTON
      // =========================================================

      outlinedButtonTheme:
      OutlinedButtonThemeData(
        style:
        OutlinedButton.styleFrom(
          foregroundColor:
          primaryColor,
          side:
          const BorderSide(
            color: primaryColor,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(8),
          ),
        ),
      ),

      // =========================================================
      // FLOATING ACTION BUTTON
      // =========================================================

      floatingActionButtonTheme:
      const FloatingActionButtonThemeData(
        backgroundColor:
        primaryColor,
        foregroundColor:
        Colors.white,
      ),

      // =========================================================
      // DIVIDER
      // =========================================================

      dividerTheme:
      const DividerThemeData(
        color: Color(0xFFE5E7EB),
        thickness: 1,
        space: 1,
      ),

      // =========================================================
      // ICON
      // =========================================================

      iconTheme:
      const IconThemeData(
        color: Color(0xFF374151),
      ),

      // =========================================================
      // DROPDOWN
      // =========================================================

      dropdownMenuTheme:
      DropdownMenuThemeData(
        inputDecorationTheme:
        InputDecorationTheme(
          filled: true,
          fillColor: lightSurface,
          border:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // DARK THEME
  // =============================================================

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.dark,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),

      scaffoldBackgroundColor:
      darkScaffold,

      fontFamily: 'Roboto',

      // =========================================================
      // APP BAR
      // =========================================================

      appBarTheme:
      const AppBarTheme(
        backgroundColor:
        darkScaffold,
        foregroundColor:
        darkText,
        elevation: 0,
        centerTitle: false,
      ),

      // =========================================================
      // CARD
      // =========================================================

      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),

      // =========================================================
      // INPUT
      // =========================================================

      inputDecorationTheme:
      InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color: Colors.white24,
          ),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color: Colors.white24,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),

        errorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color: Colors.redAccent,
          ),
        ),

        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),

      // =========================================================
      // ELEVATED BUTTON
      // =========================================================

      elevatedButtonTheme:
      ElevatedButtonThemeData(
        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          primaryColor,
          foregroundColor:
          Colors.white,
          elevation: 0,
          minimumSize:
          const Size(0, 44),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(8),
          ),
        ),
      ),

      // =========================================================
      // TEXT BUTTON
      // =========================================================

      textButtonTheme:
      TextButtonThemeData(
        style:
        TextButton.styleFrom(
          foregroundColor:
          primaryColor,
        ),
      ),

      // =========================================================
      // OUTLINED BUTTON
      // =========================================================

      outlinedButtonTheme:
      OutlinedButtonThemeData(
        style:
        OutlinedButton.styleFrom(
          foregroundColor:
          primaryColor,
          side:
          const BorderSide(
            color: primaryColor,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(8),
          ),
        ),
      ),

      // =========================================================
      // FAB
      // =========================================================

      floatingActionButtonTheme:
      const FloatingActionButtonThemeData(
        backgroundColor:
        primaryColor,
        foregroundColor:
        Colors.white,
      ),

      // =========================================================
      // DIVIDER
      // =========================================================

      dividerTheme:
      const DividerThemeData(
        color: Colors.white12,
        thickness: 1,
        space: 1,
      ),

      // =========================================================
      // ICON
      // =========================================================

      iconTheme:
      const IconThemeData(
        color: Colors.white70,
      ),

      // =========================================================
      // DROPDOWN
      // =========================================================

      dropdownMenuTheme:
      DropdownMenuThemeData(
        inputDecorationTheme:
        InputDecorationTheme(
          filled: true,
          fillColor: darkSurface,
          border:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}