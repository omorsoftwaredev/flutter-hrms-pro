import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/company_entity.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({
    super.key,
    required this.company,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  final CompanyEntity company;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  // =============================================================
  // INFO ROW
  // =============================================================

  Widget _infoRow({
    required BuildContext context,
    required IconData icon,
    required String value,
    required double iconSize,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: colorScheme.onSurfaceVariant,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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

    final double avatarSize = isDesktop
        ? 44
        : 42;

    final double headerIconSize = isDesktop
        ? 22
        : 21;

    final double infoIconSize = isDesktop
        ? 19
        : 18;

    final double spacing = isDesktop
        ? 10
        : isTablet
        ? 9
        : 8;

    final Color statusColor = company.isActive
        ? Colors.green
        : colorScheme.outline;

    return AppCard(
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
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.business_outlined,
                    color: statusColor,
                    size: headerIconSize,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    company.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                // =================================================
                // MENU
                // =================================================

                PopupMenuButton<String>(
                  tooltip: 'More actions',
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'view':
                        onView?.call();
                        break;

                      case 'edit':
                        onEdit?.call();
                        break;

                      case 'status':
                        onToggleStatus?.call();
                        break;

                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 20,
                            color: colorScheme.onSurface,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'View',
                            style:
                            theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: colorScheme.onSurface,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Edit',
                            style:
                            theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value: 'status',
                      child: Row(
                        children: [
                          Icon(
                            company.isActive
                                ? Icons.block_outlined
                                : Icons.check_circle_outline,
                            size: 20,
                            color: colorScheme.onSurface,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            company.isActive
                                ? 'Deactivate'
                                : 'Activate',
                            style:
                            theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const PopupMenuDivider(),

                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: colorScheme.error,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Delete',
                            style:
                            theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // =====================================================
            // DIVIDER
            // =====================================================

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),

            const SizedBox(height: 14),

            // =====================================================
            // EMAIL
            // =====================================================

            _infoRow(
              context: context,
              icon: Icons.email_outlined,
              value: company.email,
              iconSize: infoIconSize,
            ),

            SizedBox(height: spacing),

            // =====================================================
            // PHONE
            // =====================================================

            _infoRow(
              context: context,
              icon: Icons.phone_outlined,
              value: company.phone,
              iconSize: infoIconSize,
            ),

            SizedBox(height: spacing),

            // =====================================================
            // ADDRESS
            // =====================================================

            _infoRow(
              context: context,
              icon: Icons.location_on_outlined,
              value: company.address,
              iconSize: infoIconSize,
            ),

            const SizedBox(height: 14),

            // =====================================================
            // FOOTER DIVIDER
            // =====================================================

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),

            const SizedBox(height: 12),

            // =====================================================
            // STATUS
            // =====================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withValues(
                        alpha: 0.18,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        company.isActive
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        size: 17,
                        color: statusColor,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        company.isActive
                            ? 'Active'
                            : 'Inactive',
                        style:
                        theme.textTheme.labelMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}