import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceGoogleMap extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const AttendanceGoogleMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double mapHeight = isDesktop
        ? 320
        : isTablet
        ? 290
        : 250;

    // ===========================================================
    // LOCATION NOT AVAILABLE
    // ===========================================================

    if (latitude == null || longitude == null) {
      return Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
        child: SizedBox(
          height: mapHeight,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_off_outlined,
                  size: 30,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Location not available',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'No GPS location information is available.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ===========================================================
    // MAP POSITION
    // ===========================================================

    final position = LatLng(
      latitude!,
      longitude!,
    );

    // ===========================================================
    // GOOGLE MAP
    // ===========================================================

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: mapHeight,
          width: double.infinity,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: isDesktop ? 16.5 : 16,
            ),

            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,

            compassEnabled: true,

            mapToolbarEnabled: false,

            markers: {
              Marker(
                markerId: const MarkerId(
                  'attendance',
                ),
                position: position,
              ),
            },
          ),
        ),
      ),
    );
  }
}