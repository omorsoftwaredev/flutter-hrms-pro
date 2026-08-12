import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';

import '../../domain/entities/role_permissions_view_entity.dart';

class RolePermissionsViewPage extends StatelessWidget {
  const RolePermissionsViewPage({
    super.key,
    required this.data,
  });

  final RolePermissionsViewEntity data;

  @override
  Widget build(BuildContext context) {
    final permission = data.permission;

    return Scaffold(
      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        title: const Text(
          'Role Permission Details',
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===================================================
            // HEADER
            // ===================================================

            AppCard(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(
                      Icons.security,
                      size: 42,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Text(
                    permission.moduleName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    data.roleName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ------------------------------------------------
                  // View permission as primary status
                  // ------------------------------------------------

                  AppStatusChip(
                    isActive: permission.canView,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // ===================================================
            // DETAILS
            // ===================================================

            AppCard(
              child: Column(
                children: [
                  // ------------------------------------------------
                  // COMPANY
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.business,
                    title: 'Company',
                    value: data.companyName,
                  ),

                  // ------------------------------------------------
                  // ROLE
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.admin_panel_settings,
                    title: 'Role',
                    value: data.roleName,
                  ),

                  // ------------------------------------------------
                  // MODULE
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.extension,
                    title: 'Module Name',
                    value: permission.moduleName,
                  ),

                  // ------------------------------------------------
                  // VIEW
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.visibility,
                    title: 'View Permission',
                    value: permission.canView
                        ? 'Allowed'
                        : 'Denied',
                  ),

                  // ------------------------------------------------
                  // CREATE
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.add_circle_outline,
                    title: 'Create Permission',
                    value: permission.canCreate
                        ? 'Allowed'
                        : 'Denied',
                  ),

                  // ------------------------------------------------
                  // UPDATE
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.edit,
                    title: 'Update Permission',
                    value: permission.canUpdate
                        ? 'Allowed'
                        : 'Denied',
                  ),

                  // ------------------------------------------------
                  // DELETE
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.delete_outline,
                    title: 'Delete Permission',
                    value: permission.canDelete
                        ? 'Allowed'
                        : 'Denied',
                  ),

                  // ------------------------------------------------
                  // EXPORT
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.download,
                    title: 'Export Permission',
                    value: permission.canExport
                        ? 'Allowed'
                        : 'Denied',
                  ),

                  // ------------------------------------------------
                  // APPROVE
                  // ------------------------------------------------

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

            const SizedBox(
              height: 20,
            ),

            // ===================================================
            // AUDIT INFORMATION
            // ===================================================

            AppCard(
              child: Column(
                children: [
                  // ------------------------------------------------
                  // CREATED AT
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.access_time,
                    title: 'Created At',
                    value: permission.createdAt.toString(),
                  ),

                  // ------------------------------------------------
                  // CREATED BY
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.person_add_alt_1,
                    title: 'Created By',
                    value: permission.createdBy ?? '-',
                  ),

                  // ------------------------------------------------
                  // UPDATED AT
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.update,
                    title: 'Updated At',
                    value:
                    permission.updatedAt?.toString() ?? '-',
                  ),

                  // ------------------------------------------------
                  // UPDATED BY
                  // ------------------------------------------------

                  AppDetailTile(
                    icon: Icons.person_outline,
                    title: 'Updated By',
                    value: permission.updatedBy ?? '-',
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