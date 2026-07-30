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
    if (latitude == null || longitude == null) {
      return Card(
        child: SizedBox(
          height: 220,
          child: Center(
            child: Text(
              "Location not available",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      );
    }

    final position = LatLng(
      latitude!,
      longitude!,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 250,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 16,
          ),
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          markers: {
            Marker(
              markerId: const MarkerId("attendance"),
              position: position,
            ),
          },
        ),
      ),
    );
  }
}