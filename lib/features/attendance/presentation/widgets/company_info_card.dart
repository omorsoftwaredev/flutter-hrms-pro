import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class CompanyInfoCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const CompanyInfoCard({
    super.key,
    required this.attendance,
  });

  Widget _item(
      BuildContext context, {
        required String title,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double labelWidth = isDesktop
        ? 150
        : isTablet
        ? 140
        : 120;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isDesktop ? 14 : 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          Text(
            ": ",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(width: 4),

          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double cardPadding = isDesktop
        ? 24
        : isTablet
        ? 20
        : 16;

    final double titleSize = isDesktop
        ? 19
        : isTablet
        ? 18
        : 17;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isDesktop ? 18 : 16,
        ),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // HEADER
            // =========================================================
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.business_outlined,
                    size: 21,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    "Organization Information",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Divider(
              height: 24,
              color: colorScheme.outlineVariant,
            ),

            // =========================================================
            // INFORMATION
            // =========================================================
            _item(
              context,
              title: "Company ID",
              value: attendance.companyId ?? "--",
            ),

            _item(
              context,
              title: "Department ID",
              value: attendance.departmentId ?? "--",
            ),

            _item(
              context,
              title: "Designation ID",
              value: attendance.designationId ?? "--",
            ),

            _item(
              context,
              title: "Shift ID",
              value: attendance.shiftId ?? "--",
            ),

            _item(
              context,
              title: "Employee ID",
              value: attendance.employeeId ?? "--",
            ),
          ],
        ),
      ),
    );
  }
}