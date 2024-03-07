import 'package:android_id/android_id.dart';

class DeviceIdHelper {
  static Future<String?> getDeviceId() async {
    const _androidIdPlugin = AndroidId();
    final String? androidId = await _androidIdPlugin.getId();
    print("Andorid ID:  $androidId");
    return androidId;
  }
}
