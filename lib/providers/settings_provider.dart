import 'dart:async';
import 'dart:convert';

import 'package:device_tracker_app/helpers/device_id_helper.dart';
import 'package:device_tracker_app/models/settings_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SettingsProvider with ChangeNotifier {
  SettingsInfo? settings;
  Timer? _timer;
  String? deviceImeiNumber;

  void startTimer() {
    processSettingsData();
    _timer = Timer.periodic(Duration(seconds: 60), (Timer timer) {
      processSettingsData();
    });
  }

  void processSettingsData() async {
    deviceImeiNumber = (await DeviceIdHelper.getDeviceId());
    await getSettingsData();
    notifyListeners();
  }

  Future<void> getSettingsData() async {
    print("Getting settings");
    var uri = Uri.parse(
        'http://10.0.2.2:8080/api/devices/trackingSettingsByDevice/$deviceImeiNumber');
    try {
      final response = await http.get(uri);
      //headers: {'Content-Type': 'application/json'});
      //print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      settings = new SettingsInfo();
      settings?.meteringFrequency = extractedData['meteringFrequency'];
      settings?.isGeofenceActive = extractedData['isGeofenceActive'];
      settings?.geofenceCenterLatitude =
          extractedData['geofenceCenterLatitude'];
      settings?.geofenceCenterLongitude =
          extractedData['geofenceCenterLongitude'];
      settings?.geofenceRadius = extractedData['geofenceRadius'];
      int f = settings!.meteringFrequency;
      print("Settings: $f");
      return;
    } catch (error) {
      print('Error getting data: $error');
      throw error;
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
