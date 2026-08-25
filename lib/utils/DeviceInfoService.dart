import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  DeviceInfoService._();

  static final DeviceInfoService instance = DeviceInfoService._();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<String?> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo =
        await _deviceInfoPlugin.androidInfo;

        return androidInfo.id;
      }

      if (Platform.isIOS) {
        final IosDeviceInfo iosInfo =
        await _deviceInfoPlugin.iosInfo;

        return iosInfo.identifierForVendor;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}