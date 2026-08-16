// ===============================================================
// Flutter HRMS Pro
// App Text Field
//
// Version : 2.0.0
//
// Purpose
// - Centralized TextFormField
// - Theme aware
// - Null safe
// - Create / Edit compatible
// - Safe inside Column / ListView / Card
// - Supports single & multiline field
// ===============================================================

import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.onTap,
    this.enabled = true,
    this.autofocus = false,
  });

  // =============================================================
  // CONTROLLER
  // =============================================================

  final TextEditingController? controller;

  // =============================================================
  // LABEL / HINT
  // =============================================================

  final String? label;
  final String? hint;

  // =============================================================
  // ICONS
  // =============================================================

  final IconData? prefixIcon;
  final Widget? suffixIcon;

  // =============================================================
  // INPUT
  // =============================================================

  final TextInputType? keyboardType;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;

  final bool readOnly;

  final bool obscureText;

  final int maxLines;

  final VoidCallback? onTap;

  final bool enabled;

  final bool autofocus;

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // -----------------------------------------------------------
    // Safe multiline handling
    // -----------------------------------------------------------

    final bool isMultiline = maxLines > 1;

    return TextFormField(
      controller: controller,

      // ---------------------------------------------------------
      // INPUT
      // ---------------------------------------------------------

      keyboardType: keyboardType,

      validator: validator,

      onChanged: onChanged,

      readOnly: readOnly,

      enabled: enabled,

      autofocus: autofocus,

      onTap: onTap,

      // ---------------------------------------------------------
      // TEXT
      // ---------------------------------------------------------

      obscureText: isMultiline ? false : obscureText,

      maxLines: isMultiline ? maxLines : 1,

      // ---------------------------------------------------------
      // DECORATION
      // ---------------------------------------------------------

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        // -------------------------------------------------------
        // Prefix Icon
        // -------------------------------------------------------

        prefixIcon: prefixIcon == null
            ? null
            : Icon(
          prefixIcon,
          color: colors.onSurfaceVariant,
        ),

        // -------------------------------------------------------
        // Suffix Icon
        // -------------------------------------------------------

        suffixIcon: suffixIcon,

        // -------------------------------------------------------
        // Theme colors are inherited from InputDecorationTheme.
        //
        // We intentionally do NOT hard-code:
        // fillColor
        // border color
        // text color
        // label color
        //
        // So Light / Dark theme can control everything.
        // -------------------------------------------------------

        filled: true,

        // -------------------------------------------------------
        // Background
        //
        // Using theme surface keeps the field compatible with
        // both light and dark mode.
        // -------------------------------------------------------

        fillColor: colors.surface,

        // -------------------------------------------------------
        // Border
        // -------------------------------------------------------

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colors.outline,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colors.outlineVariant,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colors.primary,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colors.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colors.error,
            width: 2,
          ),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colors.outlineVariant,
          ),
        ),

        // -------------------------------------------------------
        // Content Padding
        // -------------------------------------------------------

        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isMultiline ? 16 : 15,
        ),
      ),
    );
  }
}