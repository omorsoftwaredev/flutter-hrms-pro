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
      final screenWidth =
          MediaQuery.sizeOf(dialogContext).width;

      final dialogWidth =
      screenWidth >= 600
          ? 500.0
          : screenWidth * 0.92;

      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =================================================
                // ICON
                // =================================================

                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color:
                    colorScheme.errorContainer,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 32,
                    color:
                    colorScheme.onErrorContainer,
                  ),
                ),

                const SizedBox(height: 18),

                // =================================================
                // TITLE
                // =================================================

                Text(
                  'Delete Company Account?',
                  textAlign: TextAlign.center,
                  style:
                  theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
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
                  style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color:
                    colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // ACCOUNT NAME
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                    colorScheme.surfaceContainerLow,
                    borderRadius:
                    BorderRadius.circular(14),
                    border: Border.all(
                      color:
                      colorScheme.outlineVariant,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                          colorScheme.primaryContainer,
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: colorScheme
                              .onPrimaryContainer,
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
                              style: theme
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                color: colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              fullName,
                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,
                              style: theme
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // =================================================
                // WARNING
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                    colorScheme.errorContainer
                        .withValues(alpha: 0.55),
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 20,
                        color:
                        colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'This action cannot be undone.',
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: colorScheme
                                .onErrorContainer,
                            fontWeight:
                            FontWeight.w700,
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
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                            false,
                          );
                        },
                        child:
                        const Text('Cancel'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: FilledButton.icon(
                        style:
                        FilledButton.styleFrom(
                          backgroundColor:
                          colorScheme.error,
                          foregroundColor:
                          colorScheme.onError,
                        ),
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                            true,
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                        ),
                        label:
                        const Text('Delete'),
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