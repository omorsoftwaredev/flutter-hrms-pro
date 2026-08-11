/// ===============================================================
/// Flutter HRMS Pro
/// Dark Theme
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';

class DarkTheme {
  const DarkTheme._();

  // =============================================================
  // COLORS
  // =============================================================

  static const Color primary = Color(0xFF64B5F6);
  static const Color secondary = Color(0xFF42A5F5);

  static const Color background = Color(0xFF101318);
  static const Color surface = Color(0xFF181C22);

  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB0B7C3);

  static const Color border = Color(0xFF303640);

  // =============================================================
  // THEME
  // =============================================================

  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: secondary,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,

      colorScheme: colorScheme,

      brightness: Brightness.dark,

      scaffoldBackgroundColor: background,

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
            color: Colors.redAccent,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.redAccent,
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
          foregroundColor: Colors.black87,

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

        backgroundColor: surface,

        contentTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 13,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      // =========================================================
      // PROGRESS
      // =========================================================

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
      ),
    );
  }
}