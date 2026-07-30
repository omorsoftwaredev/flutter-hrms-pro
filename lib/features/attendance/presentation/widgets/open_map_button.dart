import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenMapButton extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const OpenMapButton({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  Future<void> _openMap() async {
    if (latitude == null || longitude == null) {
      return;
    }

    final uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: latitude == null || longitude == null
          ? null
          : _openMap,
      icon: const Icon(Icons.map),
      label: const Text("Open in Google Maps"),
    );
  }
}