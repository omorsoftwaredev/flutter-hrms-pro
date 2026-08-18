import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class DeviceInfoCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const DeviceInfoCard({
    super.key,
    required this.attendance,
  });

  Widget _row(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double iconSize = isDesktop
        ? 21
        : 20;

    final double labelWidth = isDesktop
        ? 130
        : isTablet
        ? 120
        : 105;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 9 : 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(width: 12),

          SizedBox(
            width: labelWidth,
            height: 36,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          Text(
            ": ",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(width: 4),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
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
                    Icons.phone_android_outlined,
                    size: 21,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    "Device Information",
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

            Divider(
              height: 24,
              color: colorScheme.outlineVariant,
            ),

            // =========================================================
            // DEVICE
            // =========================================================
            _row(
              context,
              icon: Icons.smartphone_outlined,
              title: "Device",
              value: attendance.deviceName ?? "--",
            ),

            // =========================================================
            // DEVICE ID
            // =========================================================
            _row(
              context,
              icon: Icons.qr_code_rounded,
              title: "Device ID",
              value: attendance.deviceId ?? "--",
            ),

            // =========================================================
            // IP ADDRESS
            // =========================================================
            _row(
              context,
              icon: Icons.public_rounded,
              title: "IP Address",
              value: attendance.ipAddress ?? "--",
            ),
          ],
        ),
      ),
    );
  }
}