import 'package:flutter/material.dart';

class AttendanceLocationCard extends StatelessWidget {
  final String title;
  final double? latitude;
  final double? longitude;
  final String? address;
  final IconData icon;

  const AttendanceLocationCard({
    super.key,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.icon,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double horizontalPadding = isDesktop
        ? 22
        : isTablet
        ? 20
        : 16;

    final bool hasLocation =
        latitude != null && longitude != null;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // LOCATION ICON
            // =====================================================

            Container(
              width: isDesktop ? 52 : 46,
              height: isDesktop ? 52 : 46,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: isDesktop ? 25 : 22,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(width: 14),

            // =====================================================
            // LOCATION INFORMATION
            // =====================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // -------------------------------------------------
                  // TITLE
                  // -------------------------------------------------

                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // -------------------------------------------------
                  // ADDRESS
                  // -------------------------------------------------

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: colorScheme
                          .surfaceContainerHighest
                          .withOpacity(.45),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color:
                          colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            address?.trim().isNotEmpty == true
                                ? address!
                                : '--',
                            style: theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color:
                              colorScheme.onSurface,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // -------------------------------------------------
                  // COORDINATES
                  // -------------------------------------------------

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final compact =
                          constraints.maxWidth < 420;

                      if (compact) {
                        return Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _coordinateRow(
                              context,
                              label: 'Latitude',
                              value: latitude
                                  ?.toStringAsFixed(6) ??
                                  '--',
                              icon:
                              Icons.north_outlined,
                            ),
                            const SizedBox(height: 6),
                            _coordinateRow(
                              context,
                              label: 'Longitude',
                              value: longitude
                                  ?.toStringAsFixed(6) ??
                                  '--',
                              icon:
                              Icons.east_outlined,
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: _coordinateRow(
                              context,
                              label: 'Latitude',
                              value: latitude
                                  ?.toStringAsFixed(6) ??
                                  '--',
                              icon:
                              Icons.north_outlined,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _coordinateRow(
                              context,
                              label: 'Longitude',
                              value: longitude
                                  ?.toStringAsFixed(6) ??
                                  '--',
                              icon:
                              Icons.east_outlined,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // -------------------------------------------------
                  // LOCATION STATUS
                  // -------------------------------------------------

                  if (!hasLocation) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: colorScheme.error,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'GPS coordinates are not available.',
                            style: theme
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: colorScheme.error,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // COORDINATE ROW
  // ===============================================================

  Widget _coordinateRow(
      BuildContext context, {
        required String label,
        required String value,
        required IconData icon,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 15,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}