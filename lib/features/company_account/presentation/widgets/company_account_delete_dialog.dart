// ===============================================================
// Flutter HRMS Pro
// Company Account Delete Dialog
//
// Responsive + Theme Aware
//
// Version : 2.0.0
// ===============================================================

import 'package:flutter/material.dart';

Future<bool?> showCompanyAccountDeleteDialog(
    BuildContext context, {
      required String fullName,
    }) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      // ===========================================================
      // RESPONSIVE
      // ===========================================================

      final width = MediaQuery.sizeOf(dialogContext).width;

      final bool isDesktop = width >= 900;
      final bool isTablet = width >= 600 && width < 900;

      final double dialogWidth = isDesktop
          ? 500
          : isTablet
          ? 480
          : width * 0.92;

      final double dialogPadding = isDesktop
          ? 24
          : isTablet
          ? 22
          : 18;

      final double titleSize = isDesktop
          ? 20
          : 19;

      final double iconBoxSize = isDesktop
          ? 64
          : 60;

      final double iconSize = isDesktop
          ? 32
          : 30;

      final double buttonHeight = isDesktop
          ? 52
          : 50;

      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isDesktop
              ? 24
              : 16,
          vertical: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
          ),
          child: Padding(
            padding: EdgeInsets.all(dialogPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =================================================
                // ICON
                // =================================================

                Container(
                  width: iconBoxSize,
                  height: iconBoxSize,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: colorScheme.error.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: iconSize,
                    color: colorScheme.onErrorContainer,
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // TITLE
                // =================================================

                Text(
                  'Delete Company Account?',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // DESCRIPTION
                // =================================================

                Text(
                  'You are about to permanently delete this '
                      'company login account.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // ACCOUNT NAME
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 20,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),

                      const SizedBox(width: 11),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account',
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(
                                color:
                                colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              fullName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // =================================================
                // WARNING
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withValues(
                      alpha: 0.55,
                    ),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: colorScheme.error.withValues(
                        alpha: 0.10,
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
                        color: colorScheme.onErrorContainer,
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: Text(
                          'This action cannot be undone.',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(
                            color:
                            colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // =================================================
                // ACTIONS
                // =================================================

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: buttonHeight,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(
                              dialogContext,
                              false,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                            colorScheme.onSurface,
                            side: BorderSide(
                              color: colorScheme.outline,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(13),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: theme.textTheme.labelLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: SizedBox(
                        height: buttonHeight,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                            colorScheme.error,
                            foregroundColor:
                            colorScheme.onError,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(13),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(
                              dialogContext,
                              true,
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                          ),
                          label: Text(
                            'Delete',
                            style: theme.textTheme.labelLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}