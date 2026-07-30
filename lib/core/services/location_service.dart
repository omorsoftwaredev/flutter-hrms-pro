import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  const LocationService();

  /// ===============================
  /// Permission
  /// ===============================

  Future<bool> requestPermission() async {
    bool enabled =
    await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      return false;
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();
    }

    if (permission ==
        LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
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
    final places =
    await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    if (places.isEmpty) {
      return '';
    }

    final place = places.first;

    return
      '${place.street}, '
          '${place.subLocality}, '
          '${place.locality}, '
          '${place.country}';
  }

  /// ===============================
  /// Latitude
  /// ===============================

  Future<double> latitude() async {
    final p = await getCurrentPosition();

    return p.latitude;
  }

  /// ===============================
  /// Longitude
  /// ===============================

  Future<double> longitude() async {
    final p = await getCurrentPosition();

    return p.longitude;
  }

  /// ===============================
  /// Position
  /// ===============================

  Future<({
  double latitude,
  double longitude,
  String address,
  })> getLocation() async {

    final ok =
    await requestPermission();

    if (!ok) {
      throw Exception(
        'Location permission denied.',
      );
    }

    final position =
    await getCurrentPosition();

    final address =
    await getAddress(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    return (
    latitude: position.latitude,
    longitude: position.longitude,
    address: address,
    );
  }
}