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

    final screenWidth = MediaQuery.sizeOf(context).width;

    final isSmallScreen = screenWidth < 360;

    return AlertDialog(
      // ===========================================================
      // RESPONSIVE WIDTH
      // ===========================================================

      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 24,
        vertical: 24,
      ),

      // ===========================================================
      // THEME
      // ===========================================================

      backgroundColor: colorScheme.surface,

      surfaceTintColor: colorScheme.surfaceTint,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isSmallScreen ? 16 : 20,
        ),
      ),

      // ===========================================================
      // ICON
      // ===========================================================

      icon: Container(
        padding: EdgeInsets.all(
          isSmallScreen ? 12 : 14,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.errorContainer,
        ),
        child: Icon(
          Icons.delete_forever_rounded,
          size: isSmallScreen ? 32 : 40,
          color: colorScheme.onErrorContainer,
        ),
      ),

      // ===========================================================
      // TITLE
      // ===========================================================

      title: Text(
        'Delete Employee Account',
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),

      // ===========================================================
      // CONTENT
      // ===========================================================

      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420,
        ),
        child: Text(
          'Are you sure you want to delete this employee account?\n\n'
              'This action cannot be undone.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ),

      // ===========================================================
      // ACTIONS
      // ===========================================================

      actionsPadding: EdgeInsets.fromLTRB(
        isSmallScreen ? 16 : 24,
        8,
        isSmallScreen ? 16 : 24,
        isSmallScreen ? 16 : 20,
      ),

      actions: [
        // =========================================================
        // RESPONSIVE BUTTON LAYOUT
        // =========================================================

        if (isSmallScreen)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===================================================
              // CANCEL
              // ===================================================

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(
                    context,
                    false,
                  );
                },
                icon: const Icon(
                  Icons.close_rounded,
                ),
                label: const Text(
                  'Cancel',
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              // ===================================================
              // DELETE
              // ===================================================

              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    true,
                  );
                },
                icon: const Icon(
                  Icons.delete_forever_rounded,
                ),
                label: const Text(
                  'Delete',
                ),
              ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ===================================================
              // CANCEL
              // ===================================================

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(
                    context,
                    false,
                  );
                },
                icon: const Icon(
                  Icons.close_rounded,
                ),
                label: const Text(
                  'Cancel',
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // ===================================================
              // DELETE
              // ===================================================

              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    true,
                  );
                },
                icon: const Icon(
                  Icons.delete_forever_rounded,
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