import 'package:flutter/material.dart';

Future<bool?> showAttendanceDeleteDialog(
    BuildContext context,
    ) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        icon: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.error.withOpacity(.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            color: colorScheme.error,
            size: 28,
          ),
        ),

        title: Text(
          'Delete Attendance',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),

        content: Text(
          'Are you sure you want to delete this attendance?',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),

        actionsPadding: const EdgeInsets.fromLTRB(
          20,
          4,
          20,
          16,
        ),

        actions: [
          Row(
            children: [
              // ===================================================
              // CANCEL
              // ===================================================

              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize:
                    const Size.fromHeight(46),
                    foregroundColor:
                    colorScheme.onSurface,
                    side: BorderSide(
                      color: colorScheme.outline,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ===================================================
              // DELETE
              // ===================================================

              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize:
                    const Size.fromHeight(46),
                    backgroundColor:
                    colorScheme.error,
                    foregroundColor:
                    colorScheme.onError,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}