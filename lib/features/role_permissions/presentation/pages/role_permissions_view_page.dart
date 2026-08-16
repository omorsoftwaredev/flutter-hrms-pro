import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';

import '../../domain/entities/role_permissions_view_entity.dart';

class RolePermissionsViewPage extends StatelessWidget {
  const RolePermissionsViewPage({super.key, required this.data});

  final RolePermissionsViewEntity data;

  @override
  Widget build(BuildContext context) {
    final permission = data.permission;

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
          'Role Permission Details',
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
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // =====================================================
            // RESPONSIVE BREAKPOINTS
            // =====================================================

            final bool isDesktop = width >= 1000;
            final bool isTablet = width >= 600;

            final double horizontalPadding = isDesktop
                ? 32
                : isTablet
                ? 24
                : 14;

            final double maxContentWidth = isDesktop ? 900 : 760;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                32,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // =================================================
                      // HEADER
                      // =================================================
                      AppCard(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop
                                ? 32
                                : isTablet
                                ? 24
                                : 16,
                            vertical: isDesktop ? 32 : 24,
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: isDesktop ? 42 : 38,
                                child: Icon(
                                  Icons.security,
                                  size: isDesktop ? 44 : 40,
                                ),
                              ),

                              const SizedBox(height: 16),

                              Text(
                                permission.moduleName,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                data.roleName,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),

                              const SizedBox(height: 16),

                              AppStatusChip(isActive: permission.canView),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // BASIC INFORMATION
                      // =================================================
                      AppCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            children: [
                              AppDetailTile(
                                icon: Icons.business_outlined,
                                title: 'Company',
                                value: data.companyName,
                              ),

                              AppDetailTile(
                                icon: Icons.admin_panel_settings_outlined,
                                title: 'Role',
                                value: data.roleName,
                              ),

                              AppDetailTile(
                                icon: Icons.extension_outlined,
                                title: 'Module Name',
                                value: permission.moduleName,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // PERMISSIONS
                      // =================================================
                      AppCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            children: [
                              AppDetailTile(
                                icon: Icons.visibility_outlined,
                                title: 'View Permission',
                                value: permission.canView
                                    ? 'Allowed'
                                    : 'Denied',
                              ),

                              AppDetailTile(
                                icon: Icons.add_circle_outline,
                                title: 'Create Permission',
                                value: permission.canCreate
                                    ? 'Allowed'
                                    : 'Denied',
                              ),

                              AppDetailTile(
                                icon: Icons.edit_outlined,
                                title: 'Update Permission',
                                value: permission.canUpdate
                                    ? 'Allowed'
                                    : 'Denied',
                              ),

                              AppDetailTile(
                                icon: Icons.delete_outline,
                                title: 'Delete Permission',
                                value: permission.canDelete
                                    ? 'Allowed'
                                    : 'Denied',
                              ),

                              AppDetailTile(
                                icon: Icons.download_outlined,
                                title: 'Export Permission',
                                value: permission.canExport
                                    ? 'Allowed'
                                    : 'Denied',
                              ),

                              AppDetailTile(
                                icon: Icons.check_circle_outline,
                                title: 'Approve Permission',
                                value: permission.canApprove
                                    ? 'Allowed'
                                    : 'Denied',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // AUDIT INFORMATION
                      // =================================================
                      AppCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            children: [
                              AppDetailTile(
                                icon: Icons.access_time_outlined,
                                title: 'Created At',
                                value: permission.createdAt.toString(),
                              ),

                              AppDetailTile(
                                icon: Icons.person_add_alt_1_outlined,
                                title: 'Created By',
                                value: permission.createdBy ?? '-',
                              ),

                              AppDetailTile(
                                icon: Icons.update_outlined,
                                title: 'Updated At',
                                value: permission.updatedAt?.toString() ?? '-',
                              ),

                              AppDetailTile(
                                icon: Icons.person_outline,
                                title: 'Updated By',
                                value: permission.updatedBy ?? '-',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
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
