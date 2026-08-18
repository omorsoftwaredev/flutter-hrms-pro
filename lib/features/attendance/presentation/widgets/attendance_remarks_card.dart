import 'package:flutter/material.dart';

class AttendanceRemarksCard extends StatelessWidget {
  final String? remarks;

  const AttendanceRemarksCard({
    super.key,
    this.remarks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double padding = isDesktop
        ? 20
        : isTablet
        ? 18
        : 16;

    final bool hasRemarks =
        remarks?.trim().isNotEmpty ?? false;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Row(
              children: [
                Container(
                  width: isDesktop ? 44 : 40,
                  height: isDesktop ? 44 : 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary
                        .withOpacity(.10),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.sticky_note_2_outlined,
                    size: isDesktop ? 23 : 21,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Remarks',
                    style:
                    theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // =====================================================
            // REMARKS CONTENT
            // =====================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: colorScheme
                    .surfaceContainerHighest
                    .withOpacity(.40),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    hasRemarks
                        ? Icons.notes_outlined
                        : Icons.info_outline,
                    size: 18,
                    color: hasRemarks
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant,
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      hasRemarks
                          ? remarks!.trim()
                          : 'No Remarks',
                      style:
                      theme.textTheme.bodyMedium?.copyWith(
                        color: hasRemarks
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                        height: 1.45,
                        fontWeight: hasRemarks
                            ? FontWeight.w400
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}