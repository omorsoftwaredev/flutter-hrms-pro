/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Search
///
/// Version : 4.0.0
///
/// Features:
/// - Theme aware
/// - Light / Dark mode support
/// - Responsive mobile / tablet / desktop
/// - Clear button
/// - Focus aware border
/// - Modern HRMS Pro UI
/// - Material 3 compatible
/// - Controller listener safe
/// ===============================================================

import 'package:flutter/material.dart';

class SupervisorSearch extends StatefulWidget {
  const SupervisorSearch({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.enabled = true,
  });

  // =============================================================
  // CONTROLLER
  // =============================================================

  final TextEditingController controller;

  // =============================================================
  // CALLBACKS
  // =============================================================

  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  // =============================================================
  // ENABLED
  // =============================================================

  final bool enabled;

  @override
  State<SupervisorSearch> createState() =>
      _SupervisorSearchState();
}

// ===============================================================
// STATE
// ===============================================================

class _SupervisorSearchState
    extends State<SupervisorSearch> {
  // =============================================================
  // FOCUS NODE
  // =============================================================

  late final FocusNode _focusNode;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    widget.controller.addListener(
      _onControllerChanged,
    );

    _focusNode.addListener(
      _onFocusChanged,
    );
  }

  // =============================================================
  // CONTROLLER CHANGE
  // =============================================================

  void _onControllerChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // =============================================================
  // FOCUS CHANGE
  // =============================================================

  void _onFocusChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // =============================================================
  // CLEAR
  // =============================================================

  void _clear() {
    if (!widget.enabled) {
      return;
    }

    widget.controller.clear();

    widget.onClear?.call();

    widget.onChanged?.call('');

    _focusNode.requestFocus();

    if (mounted) {
      setState(() {});
    }
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    widget.controller.removeListener(
      _onControllerChanged,
    );

    _focusNode.removeListener(
      _onFocusChanged,
    );

    _focusNode.dispose();

    super.dispose();
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final width = constraints.maxWidth;

        // =======================================================
        // RESPONSIVE
        // =======================================================

        final bool isMobile = width < 600;

        final bool isTablet =
            width >= 600 && width < 1000;

        final double radius = isMobile
            ? 12
            : isTablet
            ? 13
            : 14;

        final double iconSize = isMobile
            ? 21
            : 22;

        final double horizontalPadding =
        isMobile
            ? 13
            : 16;

        final double verticalPadding =
        isMobile
            ? 12
            : 13;

        // =======================================================
        // COLORS
        // =======================================================

        final Color normalBorder =
            colorScheme.outlineVariant;

        final Color focusedBorder =
            colorScheme.primary;

        final Color iconColor =
            colorScheme.onSurfaceVariant;

        final Color fillColor =
            colorScheme.surfaceContainerLow;

        final bool hasText =
            widget.controller.text.trim().isNotEmpty;

        final bool isFocused =
            _focusNode.hasFocus;

        // =======================================================
        // BORDER
        // =======================================================

        OutlineInputBorder buildBorder({
          required Color color,
          double width = 1,
        }) {
          return OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: color,
              width: width,
            ),
          );
        }

        // =======================================================
        // TEXT FIELD
        // =======================================================

        return TextField(
          controller: widget.controller,

          focusNode: _focusNode,

          enabled: widget.enabled,

          onChanged: widget.onChanged,

          textInputAction:
          TextInputAction.search,

          keyboardType:
          TextInputType.text,

          textCapitalization:
          TextCapitalization.sentences,

          autocorrect: false,

          style:
          theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),

          cursorColor:
          colorScheme.primary,

          decoration: InputDecoration(
            // ===================================================
            // HINT
            // ===================================================

            hintText:
            'Search supervisor...',

            hintStyle:
            theme.textTheme.bodyMedium?.copyWith(
              color:
              colorScheme.onSurfaceVariant,
            ),

            // ===================================================
            // PREFIX
            // ===================================================

            prefixIcon: Padding(
              padding:
              const EdgeInsetsDirectional.only(
                start: 4,
              ),
              child: Icon(
                Icons.search_rounded,
                size: iconSize,
                color: isFocused
                    ? colorScheme.primary
                    : iconColor,
              ),
            ),

            // ===================================================
            // CLEAR
            // ===================================================

            suffixIcon: hasText
                ? IconButton(
              tooltip: 'Clear search',

              splashRadius: 20,

              onPressed:
              widget.enabled
                  ? _clear
                  : null,

              icon: Icon(
                Icons.close_rounded,
                size: 20,
              ),

              color:
              colorScheme.onSurfaceVariant,
            )
                : null,

            // ===================================================
            // DEFAULT BORDER
            // ===================================================

            border: buildBorder(
              color: normalBorder,
            ),

            // ===================================================
            // ENABLED BORDER
            // ===================================================

            enabledBorder: buildBorder(
              color: normalBorder,
            ),

            // ===================================================
            // FOCUSED BORDER
            // ===================================================

            focusedBorder: buildBorder(
              color: focusedBorder,
              width: 1.5,
            ),

            // ===================================================
            // DISABLED BORDER
            // ===================================================

            disabledBorder: buildBorder(
              color: colorScheme
                  .outline
                  .withValues(alpha: 0.12),
            ),

            // ===================================================
            // ERROR BORDER
            // ===================================================

            errorBorder: buildBorder(
              color: colorScheme.error,
            ),

            focusedErrorBorder:
            buildBorder(
              color: colorScheme.error,
              width: 1.5,
            ),

            // ===================================================
            // FILLED
            // ===================================================

            filled: true,

            fillColor: widget.enabled
                ? fillColor
                : colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.45),

            // ===================================================
            // CONTENT PADDING
            // ===================================================

            contentPadding:
            EdgeInsets.symmetric(
              horizontal:
              horizontalPadding,
              vertical:
              verticalPadding,
            ),

            // ===================================================
            // DENSITY
            // ===================================================

            isDense: isMobile,
          ),
        );
      },
    );
  }
}