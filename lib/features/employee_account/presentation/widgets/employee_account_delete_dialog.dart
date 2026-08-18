import 'package:flutter/material.dart';

class EmployeeAccountDeleteDialog extends StatelessWidget {
  const EmployeeAccountDeleteDialog({
    super.key,
  });

  // =============================================================
  // SHOW DIALOG
  // =============================================================

  static Future<bool?> show(
      BuildContext context,
      ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const EmployeeAccountDeleteDialog(),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // ===========================================================
    // RESPONSIVE
    // ===========================================================

    final isSmallScreen = screenWidth < 360;
    final isMobile = screenWidth < 600;

    final horizontalPadding = isSmallScreen
        ? 16.0
        : isMobile
        ? 20.0
        : 24.0;

    final dialogRadius = isSmallScreen ? 18.0 : 22.0;

    final iconContainerSize = isSmallScreen
        ? 64.0
        : 76.0;

    final iconSize = isSmallScreen
        ? 30.0
        : 36.0;

    // ===========================================================
    // DIALOG
    // ===========================================================

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 24,
      ),

      // =========================================================
      // THEME
      // =========================================================

      backgroundColor: colorScheme.surface,

      surfaceTintColor: colorScheme.surfaceTint,

      elevation: 8,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          dialogRadius,
        ),
      ),

      // =========================================================
      // ICON
      // =========================================================

      icon: Container(
        width: iconContainerSize,
        height: iconContainerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.errorContainer,
          border: Border.all(
            color: colorScheme.error.withValues(
              alpha: 0.12,
            ),
          ),
        ),
        child: Icon(
          Icons.delete_forever_rounded,
          size: iconSize,
          color: colorScheme.onErrorContainer,
        ),
      ),

      // =========================================================
      // TITLE
      // =========================================================

      title: Padding(
        padding: const EdgeInsets.only(
          top: 4,
        ),
        child: Text(
          'Delete Employee Account',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),

      // =========================================================
      // CONTENT
      // =========================================================

      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: screenHeight * 0.35,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to delete this employee account?',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // =================================================
              // WARNING MESSAGE
              // =================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(
                    alpha: 0.45,
                  ),
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                  border: Border.all(
                    color: colorScheme.error.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 20,
                      color: colorScheme.error,
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child: Text(
                        'This action cannot be undone.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // =========================================================
      // ACTIONS
      // =========================================================

      actionsPadding: EdgeInsets.fromLTRB(
        horizontalPadding,
        4,
        horizontalPadding,
        isSmallScreen ? 16 : 20,
      ),

      actions: [
        // =======================================================
        // SMALL SCREEN
        // =======================================================

        if (isSmallScreen)
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [
              // =================================================
              // CANCEL
              // =================================================

              SizedBox(
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      false,
                    );
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 19,
                  ),
                  label: const Text(
                    'Cancel',
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // =================================================
              // DELETE
              // =================================================

              SizedBox(
                height: 46,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                    colorScheme.error,
                    foregroundColor:
                    colorScheme.onError,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      true,
                    );
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    size: 19,
                  ),
                  label: const Text(
                    'Delete',
                  ),
                ),
              ),
            ],
          )

        // =======================================================
        // NORMAL / TABLET / DESKTOP
        // =======================================================

        else
          Row(
            mainAxisAlignment:
            MainAxisAlignment.end,
            children: [
              // =================================================
              // CANCEL
              // =================================================

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(
                    context,
                    false,
                  );
                },
                icon: const Icon(
                  Icons.close_rounded,
                  size: 19,
                ),
                label: const Text(
                  'Cancel',
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // =================================================
              // DELETE
              // =================================================

              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor:
                  colorScheme.error,
                  foregroundColor:
                  colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    true,
                  );
                },
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  size: 19,
                ),
                label: const Text(
                  'Delete',
                ),
              ),
            ],
          ),
      ],
    );
  }
}