import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/designation_entity.dart';

class DesignationViewPage extends StatelessWidget {
  const DesignationViewPage({
    super.key,
    required this.designation,
  });

  final DesignationEntity designation;

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
          'Designation Details',
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

            final double horizontalPadding = isMobile
                ? 10
                : isTablet
                ? 20
                : 32;

            // ===================================================
            // AVAILABLE HEIGHT
            //
            // SCREEN = 7 PARTS
            //
            // HEADER  = 2 PARTS
            // DETAILS = 5 PARTS
            // ===================================================

            final double availableHeight =
                height - 40 - 32;

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
                      // =================================================
                      // HEADER
                      // 2 PARTS
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: headerHeight,

                        child: _buildHeaderCard(
                          context,
                          isMobile: isMobile,
                          isTablet: isTablet,
                        ),
                      ),

                      // =================================================
                      // GAP
                      // =================================================

                      const SizedBox(height: 12),

                      // =================================================
                      // DETAILS / CHILD
                      // 5 PARTS
                      // =================================================

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
          },
        ),
      ),
    );
  }

  // =============================================================
  // HEADER CARD
  // =============================================================

  Widget _buildHeaderCard(
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
              ? 10
              : isTablet
              ? 14
              : 18,
        ),

        child: Row(
          children: [
            // ===================================================
            // ICON
            // ===================================================

            Container(
              width: isMobile
                  ? 52
                  : isTablet
                  ? 60
                  : 70,

              height: isMobile
                  ? 52
                  : isTablet
                  ? 60
                  : 70,

              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.badge_outlined,

                size: isMobile
                    ? 27
                    : isTablet
                    ? 31
                    : 36,

                color:
                colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(width: 14),

            // ===================================================
            // NAME + TYPE + STATUS
            // ===================================================

            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  // =================================================
                  // DESIGNATION NAME
                  // =================================================

                  Text(
                    designation.name,

                    maxLines: 2,

                    overflow:
                    TextOverflow.ellipsis,

                    style: theme
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w700,

                      color:
                      colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // =================================================
                  // TYPE
                  // =================================================

                  Text(
                    'Designation',

                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color:
                      colorScheme
                          .onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // =================================================
                  // STATUS
                  // =================================================

                  Align(
                    alignment:
                    Alignment.centerLeft,

                    child: AppStatusChip(
                      isActive:
                      designation.isActive,
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
        padding: const EdgeInsets.all(4),

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
                      BorderRadius.circular(
                        11,
                      ),
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

                  const SizedBox(width: 10),

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
                          'Designation Information',

                          maxLines: 1,

                          overflow:
                          TextOverflow
                              .ellipsis,

                          style: theme
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight:
                            FontWeight.w700,

                            color: colorScheme
                                .onSurface,
                          ),
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        Text(
                          'Basic information about this designation',

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
              icon: Icons.business_rounded,
              title: 'Company ID',
              value: designation.companyId,
            ),

            // ===================================================
            // DESIGNATION
            // ===================================================

            AppDetailTile(
              icon: Icons.badge_outlined,
              title: 'Designation',
              value: designation.name,
            ),

            // ===================================================
            // DESCRIPTION
            // ===================================================

            AppDetailTile(
              icon:
              Icons.description_outlined,
              title: 'Description',
              value: designation
                  .description
                  .isEmpty
                  ? '-'
                  : designation.description,
            ),

            // ===================================================
            // CREATED AT
            // ===================================================

            AppDetailTile(
              icon:
              Icons.access_time_rounded,
              title: 'Created At',
              value: designation
                  .createdAt
                  .toString(),
            ),

            // ===================================================
            // UPDATED AT
            // ===================================================

            AppDetailTile(
              icon: Icons.update_rounded,
              title: 'Updated At',
              value: designation
                  .updatedAt
                  .toString(),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}