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
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final size = MediaQuery.sizeOf(context);

    final bool isDesktop = size.width >= 900;
    final bool isTablet = size.width >= 600 && size.width < 900;

    final double horizontalPadding = isDesktop
        ? 24
        : isTablet
        ? 20
        : 16;

    final bool locationAvailable =
        latitude != null && longitude != null;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),
        child: FilledButton.icon(
          onPressed: locationAvailable ? _openMap : null,
          icon: const Icon(
            Icons.map_outlined,
          ),
          label: Text(
            locationAvailable
                ? 'Open in Google Maps'
                : 'Location Not Available',
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor:
            colorScheme.surfaceContainerHighest,
            disabledForegroundColor:
            colorScheme.onSurfaceVariant,
            minimumSize: const Size(
              double.infinity,
              52,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}