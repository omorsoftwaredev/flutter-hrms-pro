import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/role_entity.dart';

class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.role,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  final RoleEntity role;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isSmall = width < 360;
        final isCompact = width < 500;
        final isWide = width >= 700;

        final cardPadding = isSmall
            ? 14.0
            : isCompact
            ? 16.0
            : isWide
            ? 20.0
            : 18.0;

        final avatarSize = isSmall
            ? 42.0
            : isCompact
            ? 46.0
            : 50.0;

        final avatarIconSize = isSmall
            ? 21.0
            : isCompact
            ? 23.0
            : 25.0;

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // =================================================
                    // ROLE ICON
                    // =================================================

                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(
                          isSmall ? 12 : 14,
                        ),
                      ),
                      child: Icon(
                        Icons.admin_panel_settings_outlined,
                        size: avatarIconSize,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),

                    SizedBox(
                      width: isSmall ? 10 : 12,
                    ),

                    // =================================================
                    // ROLE NAME
                    // =================================================

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.roleName.trim().isEmpty
                                ? 'Unnamed Role'
                                : role.roleName.trim(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.1,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'System Role',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 4),

                    // =================================================
                    // MENU
                    // =================================================

                    PopupMenuButton<String>(
                      tooltip: 'More options',
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
                        // ===========================================
                        // VIEW
                        // ===========================================

                        const PopupMenuItem<String>(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                              ),
                              SizedBox(width: 10),
                              Text('View'),
                            ],
                          ),
                        ),

                        // ===========================================
                        // EDIT
                        // ===========================================

                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                              ),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),

                        // ===========================================
                        // STATUS
                        // ===========================================

                        PopupMenuItem<String>(
                          value: 'status',
                          child: Row(
                            children: [
                              Icon(
                                role.isActive
                                    ? Icons.block_outlined
                                    : Icons.check_circle_outline,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                role.isActive
                                    ? 'Deactivate'
                                    : 'Activate',
                              ),
                            ],
                          ),
                        ),

                        const PopupMenuDivider(),

                        // ===========================================
                        // DELETE
                        // ===========================================

                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                color: colorScheme.error,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Delete',
                                style: TextStyle(
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

                SizedBox(
                  height: isSmall ? 16 : 18,
                ),

                // =====================================================
                // DIVIDER
                // =====================================================

                Divider(
                  height: 1,
                  color: colorScheme.outlineVariant.withValues(
                    alpha: 0.55,
                  ),
                ),

                SizedBox(
                  height: isSmall ? 16 : 18,
                ),

                // =====================================================
                // DESCRIPTION
                // =====================================================

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(
                    isSmall ? 11 : 13,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.35,
                    ),
                    borderRadius: BorderRadius.circular(
                      isSmall ? 10 : 12,
                    ),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(
                        alpha: 0.35,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: isSmall ? 32 : 36,
                        height: isSmall ? 32 : 36,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          size: isSmall ? 17 : 19,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),

                      SizedBox(
                        width: isSmall ? 9 : 11,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style:
                              theme.textTheme.labelMedium?.copyWith(
                                color:
                                colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              role.description.trim().isEmpty
                                  ? '-'
                                  : role.description.trim(),
                              maxLines: 3,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              theme.textTheme.bodyMedium?.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: isSmall ? 16 : 18,
                ),

                // =====================================================
                // BOTTOM STATUS / ROLE INFO
                // =====================================================

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // =================================================
                    // STATUS LABEL
                    // =================================================

                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: role.isActive
                                  ? colorScheme.primary
                                  : colorScheme.error,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Flexible(
                            child: Text(
                              role.isActive
                                  ? 'Role is active'
                                  : 'Role is inactive',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              theme.textTheme.bodySmall?.copyWith(
                                color:
                                colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // =================================================
                    // STATUS CHIP
                    // =================================================

                    _statusChip(
                      context,
                      isActive: role.isActive,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===============================================================
  // STATUS CHIP
  // ===============================================================

  Widget _statusChip(
      BuildContext context, {
        required bool isActive,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color =
    isActive ? colorScheme.primary : colorScheme.error;

    final backgroundColor = isActive
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;

    final foregroundColor = isActive
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            size: 16,
            color: color,
          ),

          const SizedBox(width: 5),

          Text(
            isActive ? 'Active' : 'Inactive',
            style: theme.textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}