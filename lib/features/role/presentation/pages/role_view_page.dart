import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';

import '../../domain/entities/role_entity.dart';

class RoleViewPage extends StatelessWidget {
  const RoleViewPage({
    super.key,
    required this.role,
  });

  final RoleEntity role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          'Role Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final double width = constraints.maxWidth;

            final bool isDesktop = width >= 1000;

            final bool isTablet = width >= 600;

            final double horizontalPadding = isDesktop
                ? 32
                : isTablet
                ? 24
                : 14;

            final double maxContentWidth = isDesktop
                ? 900
                : 760;

            return SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                32,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxContentWidth,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                    children: [
                      // =========================================
                      // ROLE HEADER
                      // =========================================

                      AppCard(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: isDesktop ? 42 : 36,
                              backgroundColor:
                              colorScheme.primaryContainer,
                              foregroundColor:
                              colorScheme.onPrimaryContainer,
                              child: Icon(
                                Icons.admin_panel_settings_outlined,
                                size: isDesktop ? 44 : 38,
                              ),
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            Text(
                              role.roleName,
                              textAlign:
                              TextAlign.center,
                              style: theme
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            AppStatusChip(
                              isActive:
                              role.isActive,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // =========================================
                      // ROLE INFORMATION
                      // =========================================

                      AppCard(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Role Information',
                              style: theme
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            AppDetailTile(
                              title:
                              'Company ID',
                              value:
                              role.companyId,
                            ),

                            AppDetailTile(
                              title:
                              'Role Name',
                              value:
                              role.roleName,
                            ),

                            AppDetailTile(
                              title:
                              'Description',
                              value:
                              role.description
                                  .isEmpty
                                  ? '-'
                                  : role.description,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // =========================================
                      // AUDIT INFORMATION
                      // =========================================

                      AppCard(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Audit Information',
                              style: theme
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            AppDetailTile(
                              title:
                              'Created At',
                              value:
                              role.createdAt
                                  .toString(),
                            ),

                            AppDetailTile(
                              title:
                              'Updated At',
                              value:
                              role.updatedAt
                                  ?.toString() ??
                                  '-',
                            ),

                            AppDetailTile(
                              title:
                              'Created By',
                              value:
                              role.createdBy
                                  ?.isNotEmpty ==
                                  true
                                  ? role.createdBy!
                                  : '-',
                            ),

                            AppDetailTile(
                              title:
                              'Updated By',
                              value:
                              role.updatedBy
                                  ?.isNotEmpty ==
                                  true
                                  ? role.updatedBy!
                                  : '-',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // =========================================
                      // STATUS INFORMATION
                      // =========================================

                      AppCard(
                        child: Row(
                          children: [
                            Icon(
                              role.isActive
                                  ? Icons
                                  .check_circle_outline_rounded
                                  : Icons
                                  .cancel_outlined,
                              color: role.isActive
                                  ? colorScheme
                                  .primary
                                  : colorScheme
                                  .error,
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    'Status',
                                    style: theme
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color:
                                      colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 2,
                                  ),

                                  Text(
                                    role.isActive
                                        ? 'Active'
                                        : 'Inactive',
                                    style: theme
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            AppStatusChip(
                              isActive:
                              role.isActive,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}