import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/department_entity.dart';

class DepartmentViewPage extends StatelessWidget {
  const DepartmentViewPage({
    super.key,
    required this.department,
  });

  final DepartmentEntity department;

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
          'Department Details',
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
            final width = constraints.maxWidth;

            // ---------------------------------------------------
            // RESPONSIVE BREAKPOINTS
            // ---------------------------------------------------

            final bool isDesktop = width >= 1000;
            final bool isTablet = width >= 600;

            final double horizontalPadding = isDesktop
                ? 32
                : isTablet
                ? 24
                : 14;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                32,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1000,
                  ),

                  child: isDesktop
                      ? _buildDesktopLayout(
                    context,
                  )
                      : _buildMobileTabletLayout(
                    context,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =============================================================
  // MOBILE / TABLET LAYOUT
  // =============================================================

  Widget _buildMobileTabletLayout(
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // =======================================================
        // PROFILE CARD
        // =======================================================

        _buildProfileCard(context),

        const SizedBox(height: 16),

        // =======================================================
        // DETAILS CARD
        // =======================================================

        _buildDetailsCard(context),
      ],
    );
  }

  // =============================================================
  // DESKTOP LAYOUT
  // =============================================================

  Widget _buildDesktopLayout(
      BuildContext context,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =======================================================
        // LEFT - PROFILE
        // =======================================================

        Expanded(
          flex: 4,
          child: _buildProfileCard(
            context,
          ),
        ),

        const SizedBox(width: 20),

        // =======================================================
        // RIGHT - DETAILS
        // =======================================================

        Expanded(
          flex: 6,
          child: _buildDetailsCard(
            context,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // PROFILE CARD
  // =============================================================

  Widget _buildProfileCard(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===================================================
            // DEPARTMENT ICON
            // ===================================================

            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.apartment_rounded,
                size: 42,
                color: colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 18),

            // ===================================================
            // DEPARTMENT NAME
            // ===================================================

            Text(
              department.name,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            // ===================================================
            // SUBTITLE
            // ===================================================

            Text(
              'Department',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 18),

            // ===================================================
            // STATUS
            // ===================================================

            AppStatusChip(
              isActive: department.isActive,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // DETAILS CARD
  // =============================================================

  Widget _buildDetailsCard(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================================================
            // SECTION HEADER
            // ===================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                10,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: colorScheme.onPrimaryContainer,
                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Department Information',
                          style:
                          theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          'Basic information about this department',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                          theme.textTheme.bodySmall?.copyWith(
                            color:
                            colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),

            const SizedBox(height: 4),

            // ===================================================
            // COMPANY ID
            // ===================================================

            AppDetailTile(
              icon: Icons.business_rounded,
              title: 'Company ID',
              value: department.companyId,
            ),

            // ===================================================
            // DEPARTMENT NAME
            // ===================================================

            AppDetailTile(
              icon: Icons.apartment_rounded,
              title: 'Department Name',
              value: department.name,
            ),

            // ===================================================
            // DESCRIPTION
            // ===================================================

            AppDetailTile(
              icon: Icons.description_outlined,
              title: 'Description',
              value: department.description,
            ),

            // ===================================================
            // PHONE
            // ===================================================

            AppDetailTile(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: department.phone,
            ),

            // ===================================================
            // EMAIL
            // ===================================================

            AppDetailTile(
              icon: Icons.email_outlined,
              title: 'Email',
              value: department.email,
            ),

            // ===================================================
            // LOCATION
            // ===================================================

            AppDetailTile(
              icon: Icons.location_on_outlined,
              title: 'Location',
              value: department.location,
            ),

            // ===================================================
            // CREATED AT
            // ===================================================

            AppDetailTile(
              icon: Icons.access_time_rounded,
              title: 'Created At',
              value: department.createdAt.toString(),
            ),

            // ===================================================
            // UPDATED AT
            // ===================================================

            AppDetailTile(
              icon: Icons.update_rounded,
              title: 'Updated At',
              value: department.updatedAt.toString(),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}