import 'package:flutter/material.dart';

class AttendanceActionCard extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onPdf;
  final VoidCallback? onPrint;
  final VoidCallback? onEdit;

  const AttendanceActionCard({
    super.key,
    this.onShare,
    this.onPdf,
    this.onPrint,
    this.onEdit,
  });

  // =============================================================
  // ACTION ITEM
  // =============================================================

  Widget _action({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 14,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 23,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double cardPadding = isDesktop
        ? 22
        : isTablet
        ? 20
        : 16;

    final double titleSize = isDesktop
        ? 19
        : 18;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Row(
              children: [
                Container(
                  width: isDesktop ? 44 : 42,
                  height: isDesktop ? 44 : 42,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: colorScheme.primary,
                    size: isDesktop ? 22 : 21,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Actions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),

            const SizedBox(height: 6),

            // =====================================================
            // ACTIONS
            // =====================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _action(
                  context: context,
                  icon: Icons.share_outlined,
                  label: 'Share',
                  color: colorScheme.primary,
                  onTap: onShare,
                ),

                _action(
                  context: context,
                  icon: Icons.picture_as_pdf_outlined,
                  label: 'PDF',
                  color: colorScheme.error,
                  onTap: onPdf,
                ),

                _action(
                  context: context,
                  icon: Icons.print_outlined,
                  label: 'Print',
                  color: Colors.orange,
                  onTap: onPrint,
                ),

                _action(
                  context: context,
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: Colors.green,
                  onTap: onEdit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}