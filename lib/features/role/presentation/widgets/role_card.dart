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
        final bool isCompact = constraints.maxWidth < 380;

        return AppCard(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =====================================================
              // HEADER
              // =====================================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: isCompact ? 20 : 22,
                    backgroundColor:
                    colorScheme.primaryContainer,
                    foregroundColor:
                    colorScheme.onPrimaryContainer,
                    child: Icon(
                      Icons.admin_panel_settings_outlined,
                      size: isCompact ? 22 : 24,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Text(
                      role.roleName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 4,
                  ),

                  PopupMenuButton<String>(
                    tooltip: 'More options',
                    icon: const Icon(
                      Icons.more_vert_rounded,
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
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('View'),
                          ],
                        ),
                      ),

                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Edit'),
                          ],
                        ),
                      ),

                      PopupMenuItem(
                        value: 'status',
                        child: Row(
                          children: [
                            Icon(
                              role.isActive
                                  ? Icons.block_outlined
                                  : Icons
                                  .check_circle_outline,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              role.isActive
                                  ? 'Deactivate'
                                  : 'Activate',
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
                              color:
                              colorScheme.error,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color:
                                colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              const SizedBox(
                height: 10,
              ),

              // =====================================================
              // DESCRIPTION
              // =====================================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 18,
                    color:
                    colorScheme.onSurfaceVariant,
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child: Text(
                      role.description.isEmpty
                          ? '-'
                          : role.description,
                      maxLines: 3,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              // =====================================================
              // STATUS
              // =====================================================

              Align(
                alignment:
                Alignment.centerRight,
                child: Chip(
                  avatar: Icon(
                    role.isActive
                        ? Icons.check_circle
                        : Icons.cancel,
                    size: 18,
                    color: role.isActive
                        ? colorScheme.primary
                        : colorScheme.error,
                  ),
                  label: Text(
                    role.isActive
                        ? 'Active'
                        : 'Inactive',
                  ),
                  backgroundColor:
                  role.isActive
                      ? colorScheme
                      .primaryContainer
                      : colorScheme
                      .errorContainer,
                  labelStyle: TextStyle(
                    color: role.isActive
                        ? colorScheme
                        .onPrimaryContainer
                        : colorScheme
                        .onErrorContainer,
                    fontWeight:
                    FontWeight.w600,
                  ),
                  side: BorderSide.none,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}