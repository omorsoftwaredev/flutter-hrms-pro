/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Table
///
/// Version : 5.1.0
///
/// Features:
/// - Theme aware
/// - Light / Dark mode support
/// - Responsive layout
/// - Mobile / Tablet / Desktop friendly
/// - Active / Inactive status
/// - Activate / Deactivate action
/// - Delete action
///
/// NOTE:
/// - Functionalities are unchanged.
/// - Only theme, spacing and responsive UI adjusted.
/// ===============================================================

import 'package:flutter/material.dart';

class SupervisorTable extends StatelessWidget {
  final List<Map<String, dynamic>> supervisors;

  // =============================================================
  // CALLBACKS
  // =============================================================

  final ValueChanged<Map<String, dynamic>>? onToggleStatus;
  final ValueChanged<Map<String, dynamic>>? onDelete;

  const SupervisorTable({
    super.key,
    required this.supervisors,
    this.onToggleStatus,
    this.onDelete,
  });

  // =============================================================
  // NESTED MAP
  // =============================================================

  Map<String, dynamic>? _nestedMap(
      Map<String, dynamic> data,
      String key,
      ) {
    final value = data[key];

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  // =============================================================
  // EMPLOYEE NAME
  // =============================================================

  String _employeeName(
      Map<String, dynamic> supervisor,
      ) {
    final employee = _nestedMap(
      supervisor,
      'employees',
    );

    if (employee == null) {
      return '-';
    }

    final fullName =
    employee['full_name']
        ?.toString()
        .trim();

    if (fullName != null &&
        fullName.isNotEmpty) {
      return fullName;
    }

    final firstName =
        employee['first_name']
            ?.toString()
            .trim() ??
            '';

    final lastName =
        employee['last_name']
            ?.toString()
            .trim() ??
            '';

    final name =
    '$firstName $lastName'.trim();

    return name.isEmpty ? '-' : name;
  }

  // =============================================================
  // DEPARTMENT NAME
  // =============================================================

  String _departmentName(
      Map<String, dynamic> supervisor,
      ) {
    final department = _nestedMap(
      supervisor,
      'departments',
    );

    if (department == null) {
      return '-';
    }

    final name =
    department['name']
        ?.toString()
        .trim();

    if (name == null ||
        name.isEmpty) {
      return '-';
    }

    return name;
  }

  // =============================================================
  // STATUS
  // =============================================================

  bool _isActive(
      Map<String, dynamic> supervisor,
      ) {
    return supervisor['is_active'] == true;
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ===========================================================
    // EMPTY
    // ===========================================================

    if (supervisors.isEmpty) {
      return _buildEmptyState(
        context,
        theme,
        colorScheme,
      );
    }

    // ===========================================================
    // RESPONSIVE LIST
    // ===========================================================

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final width =
            constraints.maxWidth;

        final bool isMobile =
            width < 600;

        final bool isTablet =
            width >= 600 &&
                width < 1000;

        final double horizontalPadding =
        isMobile
            ? 0
            : isTablet
            ? 6
            : 10;

        final double itemGap =
        isMobile
            ? 10
            : isTablet
            ? 12
            : 14;

        return ListView.separated(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: 2,
            bottom: isMobile
                ? 80
                : 90,
          ),

          itemCount:
          supervisors.length,

          separatorBuilder:
              (
              context,
              index,
              ) {
            return SizedBox(
              height: itemGap,
            );
          },

          itemBuilder:
              (
              context,
              index,
              ) {
            final supervisor =
            supervisors[index];

            final employeeName =
            _employeeName(
              supervisor,
            );

            final departmentName =
            _departmentName(
              supervisor,
            );

            final isActive =
            _isActive(
              supervisor,
            );

            final supervisorId =
            supervisor['id']
                ?.toString();

            final hasId =
                supervisorId != null &&
                    supervisorId.isNotEmpty;

            return _SupervisorCard(
              supervisor:
              supervisor,
              employeeName:
              employeeName,
              departmentName:
              departmentName,
              isActive:
              isActive,
              hasId:
              hasId,
              isMobile:
              isMobile,
              isTablet:
              isTablet,
              onToggleStatus:
              onToggleStatus,
              onDelete:
              onDelete,
            );
          },
        );
      },
    );
  }

  // =============================================================
  // EMPTY STATE
  // =============================================================

  Widget _buildEmptyState(
      BuildContext context,
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),

      decoration:
      BoxDecoration(
        color: colorScheme.surface,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),

      child: Column(
        mainAxisSize:
        MainAxisSize.min,

        children: [
          Container(
            width: 58,
            height: 58,

            decoration:
            BoxDecoration(
              color: colorScheme
                  .surfaceContainerHighest,

              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(
              Icons
                  .supervisor_account_outlined,

              size: 30,

              color: colorScheme
                  .onSurfaceVariant,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            'No supervisors found',

            textAlign:
            TextAlign.center,

            style: theme
                .textTheme
                .titleSmall
                ?.copyWith(
              fontWeight:
              FontWeight.w600,

              color:
              colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// SUPERVISOR CARD
// =================================================================

class _SupervisorCard
    extends StatelessWidget {
  const _SupervisorCard({
    required this.supervisor,
    required this.employeeName,
    required this.departmentName,
    required this.isActive,
    required this.hasId,
    required this.isMobile,
    required this.isTablet,
    this.onToggleStatus,
    this.onDelete,
  });

  final Map<String, dynamic>
  supervisor;

  final String employeeName;
  final String departmentName;

  final bool isActive;
  final bool hasId;

  final bool isMobile;
  final bool isTablet;

  final ValueChanged<
      Map<String, dynamic>>?
  onToggleStatus;

  final ValueChanged<
      Map<String, dynamic>>?
  onDelete;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    // ===========================================================
    // STATUS COLORS
    // ===========================================================

    final Color statusColor =
    isActive
        ? colorScheme.primary
        : colorScheme.error;

    final Color statusBackground =
    isActive
        ? colorScheme.primary
        .withValues(
      alpha: 0.10,
    )
        : colorScheme.error
        .withValues(
      alpha: 0.10,
    );

    // ===========================================================
    // RESPONSIVE VALUES
    // ===========================================================

    final double cardRadius =
    isMobile
        ? 16
        : isTablet
        ? 17
        : 18;

    final double cardPadding =
    isMobile
        ? 14
        : isTablet
        ? 16
        : 18;

    final double avatarSize =
    isMobile
        ? 44
        : isTablet
        ? 46
        : 48;

    final double avatarIconSize =
    isMobile
        ? 23
        : isTablet
        ? 25
        : 27;

    return Container(
      width: double.infinity,

      decoration:
      BoxDecoration(
        color:
        colorScheme.surface,

        borderRadius:
        BorderRadius.circular(
          cardRadius,
        ),

        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),

        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(
              alpha:
              theme.brightness ==
                  Brightness.dark
                  ? 0.18
                  : 0.06,
            ),

            blurRadius:
            isMobile ? 8 : 10,

            offset:
            const Offset(
              0,
              3,
            ),
          ),
        ],
      ),

      child: Padding(
        padding:
        EdgeInsets.all(
          cardPadding,
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .start,

          children: [
            // ===================================================
            // HEADER
            // ===================================================

            Row(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [
                // =================================================
                // AVATAR
                // =================================================

                Container(
                  width:
                  avatarSize,

                  height:
                  avatarSize,

                  decoration:
                  BoxDecoration(
                    color:
                    statusBackground,

                    borderRadius:
                    BorderRadius
                        .circular(
                      isMobile
                          ? 13
                          : 14,
                    ),
                  ),

                  child: Icon(
                    Icons
                        .supervisor_account_outlined,

                    color:
                    statusColor,

                    size:
                    avatarIconSize,
                  ),
                ),

                SizedBox(
                  width:
                  isMobile
                      ? 10
                      : 12,
                ),

                // =================================================
                // EMPLOYEE INFO
                // =================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [
                      Text(
                        employeeName,

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

                          color:
                          colorScheme
                              .onSurface,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons
                                .business_outlined,

                            size: 15,

                            color:
                            colorScheme
                                .onSurfaceVariant,
                          ),

                          const SizedBox(
                            width: 5,
                          ),

                          Expanded(
                            child:
                            Text(
                              departmentName,

                              maxLines:
                              1,

                              overflow:
                              TextOverflow
                                  .ellipsis,

                              style: theme
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color:
                                colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width:
                  isMobile
                      ? 6
                      : 8,
                ),

                // =================================================
                // STATUS
                // =================================================

                _StatusBadge(
                  isActive:
                  isActive,
                ),
              ],
            ),

            SizedBox(
              height:
              isMobile
                  ? 14
                  : 16,
            ),

            Divider(
              height: 1,

              color:
              colorScheme
                  .outlineVariant,
            ),

            SizedBox(
              height:
              isMobile
                  ? 12
                  : 14,
            ),

            // ===================================================
            // ACTIONS
            // ===================================================

            if (isMobile)
              Column(
                children: [
                  _buildToggleButton(
                    context,
                  ),

                  const SizedBox(
                    height: 9,
                  ),

                  _buildDeleteButton(
                    context,
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child:
                    _buildToggleButton(
                      context,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child:
                    _buildDeleteButton(
                      context,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // TOGGLE BUTTON
  // =============================================================

  Widget _buildToggleButton(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final Color color =
    isActive
        ? colorScheme.tertiary
        : colorScheme.primary;

    return SizedBox(
      width:
      double.infinity,

      height:
      isMobile ? 46 : 48,

      child:
      OutlinedButton.icon(
        onPressed:
        hasId &&
            onToggleStatus !=
                null
            ? () {
          onToggleStatus!(
            supervisor,
          );
        }
            : null,

        icon: Icon(
          isActive
              ? Icons
              .toggle_on_outlined
              : Icons
              .toggle_off_outlined,

          size: 22,
        ),

        label: Text(
          isActive
              ? 'Deactivate'
              : 'Activate',
        ),

        style:
        OutlinedButton
            .styleFrom(
          foregroundColor:
          color,

          side:
          BorderSide(
            color:
            color,
          ),

          padding:
          EdgeInsets.symmetric(
            vertical:
            isMobile
                ? 10
                : 11,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              12,
            ),
          ),

          textStyle: theme
              .textTheme
              .labelLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // DELETE BUTTON
  // =============================================================

  Widget _buildDeleteButton(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return SizedBox(
      width:
      double.infinity,

      height:
      isMobile ? 46 : 48,

      child:
      OutlinedButton.icon(
        onPressed:
        hasId &&
            onDelete !=
                null
            ? () {
          onDelete!(
            supervisor,
          );
        }
            : null,

        icon: Icon(
          Icons.delete_outline,

          size: 21,

          color:
          colorScheme.error,
        ),

        label:
        const Text(
          'Delete',
        ),

        style:
        OutlinedButton
            .styleFrom(
          foregroundColor:
          colorScheme.error,

          side:
          BorderSide(
            color:
            colorScheme.error,
          ),

          padding:
          EdgeInsets.symmetric(
            vertical:
            isMobile
                ? 10
                : 11,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              12,
            ),
          ),

          textStyle: theme
              .textTheme
              .labelLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// =================================================================
// STATUS BADGE
// =================================================================

class _StatusBadge
    extends StatelessWidget {
  const _StatusBadge({
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    // ===========================================================
    // THEME COLORS
    // ===========================================================

    final Color color =
    isActive
        ? colorScheme.primary
        : colorScheme.error;

    final Color background =
    isActive
        ? colorScheme.primary
        .withValues(
      alpha: 0.10,
    )
        : colorScheme.error
        .withValues(
      alpha: 0.10,
    );

    // ===========================================================
    // RESPONSIVE
    // ===========================================================

    return Container(
      padding:
      const EdgeInsets
          .symmetric(
        horizontal: 9,
        vertical: 6,
      ),

      decoration:
      BoxDecoration(
        color:
        background,

        borderRadius:
        BorderRadius.circular(
          20,
        ),

        border: Border.all(
          color: color.withValues(
            alpha: 0.15,
          ),
        ),
      ),

      child: Row(
        mainAxisSize:
        MainAxisSize.min,

        children: [
          Container(
            width: 7,
            height: 7,

            decoration:
            BoxDecoration(
              shape:
              BoxShape.circle,

              color:
              color,
            ),
          ),

          const SizedBox(
            width: 6,
          ),

          Text(
            isActive
                ? 'Active'
                : 'Inactive',

            style: theme
                .textTheme
                .labelSmall
                ?.copyWith(
              color:
              color,

              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}