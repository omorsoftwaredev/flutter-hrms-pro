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
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.fillColor,
  });

  final TextEditingController? controller;

  final String? label;
  final String? hint;

  final IconData? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onTap;

  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final bool autofocus;

  final int maxLines;
  final int? minLines;
  final int? maxLength;

  final TextCapitalization textCapitalization;

  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: obscureText,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      textCapitalization: textCapitalization,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon:
        prefixIcon != null ? Icon(prefixIcon) : null,

        suffixIcon: suffixIcon,

        filled: true,
        fillColor:
        fillColor ??
            theme.colorScheme.surfaceContainerLowest,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}