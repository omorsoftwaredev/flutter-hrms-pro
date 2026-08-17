/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Table
///
/// Version : 5.0.0
///
/// Features:
/// - Theme aware
/// - Light / Dark mode support
/// - Responsive layout
/// - Mobile / Tablet / Desktop friendly
/// - Active / Inactive status
/// - Activate / Deactivate action
/// - Delete action
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

  Map<String, dynamic>? _nestedMap(Map<String, dynamic> data, String key) {
    final value = data[key];

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  // =============================================================
  // EMPLOYEE NAME
  // =============================================================

  String _employeeName(Map<String, dynamic> supervisor) {
    final employee = _nestedMap(supervisor, 'employees');

    if (employee == null) {
      return '-';
    }

    final fullName = employee['full_name']?.toString().trim();

    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    final firstName = employee['first_name']?.toString().trim() ?? '';

    final lastName = employee['last_name']?.toString().trim() ?? '';

    final name = '$firstName $lastName'.trim();

    return name.isEmpty ? '-' : name;
  }

  // =============================================================
  // DEPARTMENT NAME
  // =============================================================

  String _departmentName(Map<String, dynamic> supervisor) {
    final department = _nestedMap(supervisor, 'departments');

    if (department == null) {
      return '-';
    }

    final name = department['name']?.toString().trim();

    if (name == null || name.isEmpty) {
      return '-';
    }

    return name;
  }

  // =============================================================
  // STATUS
  // =============================================================

  bool _isActive(Map<String, dynamic> supervisor) {
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
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.supervisor_account_outlined,
              size: 45,
              color: colorScheme.onSurfaceVariant,
            ),

            const SizedBox(height: 10),

            Text(
              'No supervisors found',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    // ===========================================================
    // RESPONSIVE LIST
    // ===========================================================

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 600;
        final bool isTablet = width >= 600 && width < 1000;

        final double horizontalPadding = isMobile
            ? 0
            : isTablet
            ? 4
            : 8;

        return ListView.separated(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            bottom: 90,
          ),

          itemCount: supervisors.length,

          separatorBuilder: (context, index) {
            return const SizedBox(height: 12);
          },

          itemBuilder: (context, index) {
            final supervisor = supervisors[index];

            final employeeName = _employeeName(supervisor);

            final departmentName = _departmentName(supervisor);

            final isActive = _isActive(supervisor);

            final supervisorId = supervisor['id']?.toString();

            final hasId = supervisorId != null && supervisorId.isNotEmpty;

            return _SupervisorCard(
              supervisor: supervisor,
              employeeName: employeeName,
              departmentName: departmentName,
              isActive: isActive,
              hasId: hasId,
              isMobile: isMobile,
              onToggleStatus: onToggleStatus,
              onDelete: onDelete,
            );
          },
        );
      },
    );
  }
}

// =================================================================
// SUPERVISOR CARD
// =================================================================

class _SupervisorCard extends StatelessWidget {
  const _SupervisorCard({
    required this.supervisor,
    required this.employeeName,
    required this.departmentName,
    required this.isActive,
    required this.hasId,
    required this.isMobile,
    this.onToggleStatus,
    this.onDelete,
  });

  final Map<String, dynamic> supervisor;

  final String employeeName;
  final String departmentName;

  final bool isActive;
  final bool hasId;
  final bool isMobile;

  final ValueChanged<Map<String, dynamic>>? onToggleStatus;
  final ValueChanged<Map<String, dynamic>>? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ===========================================================
    // STATUS COLORS
    // ===========================================================

    final Color statusColor = isActive ? Colors.green : colorScheme.error;

    final Color statusBackground = isActive
        ? Colors.green.withValues(alpha: 0.10)
        : colorScheme.error.withValues(alpha: 0.10);

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: colorScheme.surface,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: colorScheme.outlineVariant),

        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Padding(
        padding: EdgeInsets.all(isMobile ? 14 : 16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ===================================================
            // HEADER
            // ===================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // =================================================
                // AVATAR
                // =================================================
                Container(
                  width: isMobile ? 44 : 48,
                  height: isMobile ? 44 : 48,

                  decoration: BoxDecoration(
                    color: statusBackground,

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Icon(
                    Icons.supervisor_account_outlined,

                    color: statusColor,

                    size: isMobile ? 24 : 27,
                  ),
                ),

                const SizedBox(width: 12),

                // =================================================
                // EMPLOYEE INFO
                // =================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        employeeName,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Icon(
                            Icons.business_outlined,

                            size: 15,

                            color: colorScheme.onSurfaceVariant,
                          ),

                          const SizedBox(width: 5),

                          Expanded(
                            child: Text(
                              departmentName,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // =================================================
                // STATUS
                // =================================================
                _StatusBadge(isActive: isActive),
              ],
            ),

            const SizedBox(height: 16),

            Divider(height: 1, color: colorScheme.outlineVariant),

            const SizedBox(height: 14),

            // ===================================================
            // ACTIONS
            // ===================================================
            if (isMobile)
              Column(
                children: [
                  _buildToggleButton(context),

                  const SizedBox(height: 10),

                  _buildDeleteButton(context),
                ],
              )
            else
              Row(
                children: [
                  Expanded(child: _buildToggleButton(context)),

                  const SizedBox(width: 10),

                  Expanded(child: _buildDeleteButton(context)),
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

  Widget _buildToggleButton(BuildContext context) {
    final theme = Theme.of(context);

    final color = isActive ? Colors.orange : Colors.green;

    return SizedBox(
      width: double.infinity,

      child: OutlinedButton.icon(
        onPressed: hasId && onToggleStatus != null
            ? () {
                onToggleStatus!(supervisor);
              }
            : null,

        icon: Icon(
          isActive ? Icons.toggle_on_outlined : Icons.toggle_off_outlined,
          size: 22,
        ),

        label: Text(isActive ? 'Deactivate' : 'Activate'),

        style: OutlinedButton.styleFrom(
          foregroundColor: color,

          side: BorderSide(color: color),

          padding: const EdgeInsets.symmetric(vertical: 12),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // DELETE BUTTON
  // =============================================================

  Widget _buildDeleteButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,

      child: OutlinedButton.icon(
        onPressed: hasId && onDelete != null
            ? () {
                onDelete!(supervisor);
              }
            : null,

        icon: const Icon(Icons.delete_outline, size: 21),

        label: const Text('Delete'),

        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.error,

          side: BorderSide(color: colorScheme.error),

          padding: const EdgeInsets.symmetric(vertical: 12),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// =================================================================
// STATUS BADGE
// =================================================================

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color = isActive ? Colors.green : colorScheme.error;

    final background = isActive
        ? Colors.green.withValues(alpha: 0.10)
        : colorScheme.error.withValues(alpha: 0.10);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: background,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            width: 7,
            height: 7,

            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),

          const SizedBox(width: 6),

          Text(
            isActive ? 'Active' : 'Inactive',

            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
