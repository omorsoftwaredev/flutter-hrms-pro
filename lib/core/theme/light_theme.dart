/// ===============================================================
/// Flutter HRMS Pro
/// Light Theme
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';

class LightTheme {
  const LightTheme._();

  // =============================================================
  // COLORS
  // =============================================================

  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF1976D2);

  static const Color background = Color(0xFFFFF9FF);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color border = Color(0xFFE0E0E0);

  // =============================================================
  // THEME
  // =============================================================

  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: background,

      brightness: Brightness.light,

      // =========================================================
      // APP BAR
      // =========================================================

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      // =========================================================
      // TEXT
      // =========================================================

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: textSecondary,
        ),
        labelSmall: TextStyle(
          color: textSecondary,
        ),
      ),

      // =========================================================
      // INPUT
      // =========================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),

        labelStyle: const TextStyle(
          color: textSecondary,
        ),

        hintStyle: const TextStyle(
          color: textSecondary,
        ),
      ),

      // =========================================================
      // BUTTON
      // =========================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,

          elevation: 0,

          minimumSize: const Size(
            0,
            46,
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // OUTLINED BUTTON
      // =========================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,

          minimumSize: const Size(
            0,
            46,
          ),

          side: const BorderSide(
            color: primary,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // TEXT BUTTON
      // =========================================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,

          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // CARD
      // =========================================================

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,

        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: border,
          ),
        ),
      ),

      // =========================================================
      // DIVIDER
      // =========================================================

      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      // =========================================================
      // ICON
      // =========================================================

      iconTheme: const IconThemeData(
        color: textPrimary,
      ),

      // =========================================================
      // CHECKBOX
      // =========================================================

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // =========================================================
      // RADIO
      // =========================================================

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return primary;
            }

            return textSecondary;
          },
        ),
      ),

      // =========================================================
      // SWITCH
      // =========================================================

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return primary;
            }

            return Colors.grey;
          },
        ),
      ),

      // =========================================================
      // DROPDOWN
      // =========================================================

      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: border,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: border,
            ),
          ),
        ),
      ),

      // =========================================================
      // DIALOG
      // =========================================================

      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // =========================================================
      // SNACKBAR
      // =========================================================

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,

        backgroundColor: textPrimary,

        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      // =========================================================
      // PROGRESS INDICATOR
      // =========================================================

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
      ),
    );
  }
}