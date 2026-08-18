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
            final height = constraints.maxHeight;

            final bool isMobile = width < 600;
            final bool isTablet = width >= 600 && width < 1000;
            final bool isDesktop = width >= 1000;

            final double horizontalPadding = isMobile
                ? 10
                : isTablet
                ? 20
                : 32;

            // ===================================================
            // MOBILE / TABLET
            //
            // 7 PARTS
            // HEADER  = 2
            // DETAILS = 5
            //
            // ===================================================

            if (!isDesktop) {
              final double availableHeight =
              (height - 40 - 32).clamp(0, double.infinity);

              final double onePart =
                  availableHeight / 7;

              final double headerHeight =
                  onePart * 2;

              final double detailsHeight =
                  onePart * 5;

              return SingleChildScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(),

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

                    child: Column(
                      children: [
                        // =========================================
                        // HEADER
                        // 2 PARTS
                        // =========================================

                        SizedBox(
                          width: double.infinity,
                          height: headerHeight,
                          child: _buildProfileCard(
                            context,
                            isMobile: isMobile,
                            isTablet: isTablet,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // =========================================
                        // DETAILS
                        // 5 PARTS
                        // =========================================

                        SizedBox(
                          width: double.infinity,
                          height: detailsHeight,
                          child: _buildDetailsCard(
                            context,
                            isMobile: isMobile,
                            isTablet: isTablet,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            // ===================================================
            // DESKTOP
            //
            // PROFILE = 4
            // DETAILS = 6
            //
            // ===================================================

            return SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),

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

                  child: _buildDesktopLayout(
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
  // DESKTOP LAYOUT
  // =============================================================

  Widget _buildDesktopLayout(
      BuildContext context,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: _buildProfileCard(
            context,
            isMobile: false,
            isTablet: false,
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          flex: 6,
          child: _buildDetailsCard(
            context,
            isMobile: false,
            isTablet: false,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // PROFILE CARD
  // =============================================================

  Widget _buildProfileCard(
      BuildContext context, {
        required bool isMobile,
        required bool isTablet,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(
          isMobile
              ? 8
              : isTablet
              ? 12
              : 18,
        ),

        child: isMobile || isTablet
            ? _buildCompactProfile(
          context,
          isMobile: isMobile,
          isTablet: isTablet,
        )
            : _buildDesktopProfile(
          context,
        ),
      ),
    );
  }

  // =============================================================
  // MOBILE / TABLET PROFILE
  // =============================================================

  Widget _buildCompactProfile(
      BuildContext context, {
        required bool isMobile,
        required bool isTablet,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final double availableHeight =
            constraints.maxHeight;

        // -------------------------------------------------------
        // Adaptive sizes
        // -------------------------------------------------------

        final double iconSize = isMobile
            ? (availableHeight < 150 ? 42 : 52)
            : (availableHeight < 180 ? 50 : 60);

        final double iconContainerSize =
            iconSize + 8;

        final double titleFontSize =
        isMobile ? 17 : 20;

        return Center(
          child: SingleChildScrollView(
            physics:
            const NeverScrollableScrollPhysics(),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [
                // =================================================
                // ICON
                // =================================================

                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,

                  decoration: BoxDecoration(
                    color:
                    colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.apartment_rounded,
                    size: iconSize,
                    color:
                    colorScheme.onPrimaryContainer,
                  ),
                ),

                SizedBox(
                  height: isMobile ? 6 : 8,
                ),

                // =================================================
                // NAME
                // =================================================

                Text(
                  department.name,

                  textAlign: TextAlign.center,

                  maxLines: 2,

                  overflow:
                  TextOverflow.ellipsis,

                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontSize: titleFontSize,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 2),

                // =================================================
                // TYPE
                // =================================================

                Text(
                  'Department',

                  textAlign:
                  TextAlign.center,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                  ),
                ),

                SizedBox(
                  height: isMobile ? 5 : 7,
                ),

                // =================================================
                // STATUS
                // =================================================

                AppStatusChip(
                  isActive:
                  department.isActive,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =============================================================
  // DESKTOP PROFILE
  // =============================================================

  Widget _buildDesktopProfile(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // =======================================================
        // ICON
        // =======================================================

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
            color:
            colorScheme.onPrimaryContainer,
          ),
        ),

        const SizedBox(height: 18),

        // =======================================================
        // NAME
        // =======================================================

        Text(
          department.name,

          textAlign: TextAlign.center,

          maxLines: 3,

          overflow:
          TextOverflow.ellipsis,

          style: theme
              .textTheme
              .headlineSmall
              ?.copyWith(
            fontWeight: FontWeight.w700,
            color:
            colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 8),

        // =======================================================
        // TYPE
        // =======================================================

        Text(
          'Department',

          textAlign: TextAlign.center,

          style: theme
              .textTheme
              .bodyMedium
              ?.copyWith(
            color:
            colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 18),

        // =======================================================
        // STATUS
        // =======================================================

        AppStatusChip(
          isActive:
          department.isActive,
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  // =============================================================
  // DETAILS CARD
  // =============================================================

  Widget _buildDetailsCard(
      BuildContext context, {
        required bool isMobile,
        required bool isTablet,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      child: SingleChildScrollView(
        physics:
        const AlwaysScrollableScrollPhysics(),

        padding:
        const EdgeInsets.all(4),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // ===================================================
            // SECTION HEADER
            // ===================================================

            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 8 : 12,
                8,
                isMobile ? 8 : 12,
                10,
              ),

              child: Row(
                children: [
                  // =================================================
                  // INFO ICON
                  // =================================================

                  Container(
                    width: isMobile
                        ? 36
                        : 40,

                    height: isMobile
                        ? 36
                        : 40,

                    decoration:
                    BoxDecoration(
                      color: colorScheme
                          .primaryContainer,

                      borderRadius:
                      BorderRadius
                          .circular(11),
                    ),

                    child: Icon(
                      Icons
                          .info_outline_rounded,

                      color: colorScheme
                          .onPrimaryContainer,

                      size: isMobile
                          ? 19
                          : 21,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  // =================================================
                  // TITLE
                  // =================================================

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [
                        Text(
                          'Department Information',

                          maxLines: 1,

                          overflow:
                          TextOverflow
                              .ellipsis,

                          style: theme
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight:
                            FontWeight
                                .w700,

                            color: colorScheme
                                .onSurface,
                          ),
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        Text(
                          'Basic information about this department',

                          maxLines: 2,

                          overflow:
                          TextOverflow
                              .ellipsis,

                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===================================================
            // DIVIDER
            // ===================================================

            Divider(
              height: 1,
              color:
              colorScheme.outlineVariant,
            ),

            const SizedBox(height: 4),

            // ===================================================
            // COMPANY ID
            // ===================================================

            AppDetailTile(
              icon:
              Icons.business_rounded,
              title: 'Company ID',
              value:
              department.companyId,
            ),

            // ===================================================
            // DEPARTMENT NAME
            // ===================================================

            AppDetailTile(
              icon:
              Icons.apartment_rounded,
              title: 'Department Name',
              value:
              department.name,
            ),

            // ===================================================
            // DESCRIPTION
            // ===================================================

            AppDetailTile(
              icon:
              Icons.description_outlined,
              title: 'Description',
              value:
              department.description
                  .isEmpty
                  ? '-'
                  : department.description,
            ),

            // ===================================================
            // PHONE
            // ===================================================

            AppDetailTile(
              icon:
              Icons.phone_outlined,
              title: 'Phone',
              value:
              department.phone.isEmpty
                  ? '-'
                  : department.phone,
            ),

            // ===================================================
            // EMAIL
            // ===================================================

            AppDetailTile(
              icon:
              Icons.email_outlined,
              title: 'Email',
              value:
              department.email.isEmpty
                  ? '-'
                  : department.email,
            ),

            // ===================================================
            // LOCATION
            // ===================================================

            AppDetailTile(
              icon:
              Icons.location_on_outlined,
              title: 'Location',
              value:
              department.location
                  .isEmpty
                  ? '-'
                  : department.location,
            ),

            // ===================================================
            // CREATED AT
            // ===================================================

            AppDetailTile(
              icon:
              Icons.access_time_rounded,
              title: 'Created At',
              value:
              department.createdAt
                  .toString(),
            ),

            // ===================================================
            // UPDATED AT
            // ===================================================

            AppDetailTile(
              icon:
              Icons.update_rounded,
              title: 'Updated At',
              value:
              department.updatedAt
                  .toString(),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}