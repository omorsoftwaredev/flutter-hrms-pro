import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  const LocationService();

  /// ===============================
  /// Permission
  /// ===============================

  Future<bool> requestPermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      return false;
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// ===============================
  /// Current Position
  /// ===============================

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );
  }

  /// ===============================
  /// Address
  /// ===============================

  Future<String> getAddress({
    required double latitude,
    required double longitude,
  }) async {
    final places = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    if (places.isEmpty) {
      return '';
    }

    final place = places.first;

    return '${place.street}, '
        '${place.subLocality}, '
        '${place.locality}, '
        '${place.country}';
  }

  /// ===============================
  /// Latitude
  /// ===============================

  Future<double> latitude() async {
    final position = await getCurrentPosition();

    return position.latitude;
  }

  /// ===============================
  /// Longitude
  /// ===============================

  Future<double> longitude() async {
    final position = await getCurrentPosition();

    return position.longitude;
  }

  /// ===============================
  /// Complete Location
  /// ===============================
  ///
  /// Returns:
  /// - Latitude
  /// - Longitude
  /// - Address
  /// - Accuracy (meters)
  ///

  Future<({
  double latitude,
  double longitude,
  String address,
  double accuracy,
  })> getLocation() async {
    // Check permission
    final permissionGranted = await requestPermission();

    if (!permissionGranted) {
      throw Exception(
        'Location permission denied.',
      );
    }

    // Get current GPS position
    final position = await getCurrentPosition();

    // Get address from coordinates
    final address = await getAddress(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    // Return complete location information
    return (
    latitude: position.latitude,
    longitude: position.longitude,
    address: address,
    accuracy: position.accuracy,
    );
  }
}