import 'dart:async';
import 'dart:convert';

import 'package:device_tracker_app/helpers/device_id_helper.dart';
import 'package:device_tracker_app/helpers/location_helper.dart';
import 'package:device_tracker_app/models/location_info.dart';
import 'package:device_tracker_app/models/settings_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {
  LocationInfo? locationInfo;
  Timer? _timer;
  SettingsInfo? settings;

  //LocationProvider(this.settings);

  LocationProvider update(SettingsInfo? newSettings) {
    settings = newSettings;
    print("Metering freq in loc provider: ");
    print(this.settings?.meteringFrequency);
    stopTimer();
    startTimer();
    return this;
  }

  void startTimer() {
    processLocationData();
    print("startTimer");
    print(settings?.meteringFrequency);
    _timer = Timer.periodic(Duration(seconds: settings?.meteringFrequency ?? 3),
        (Timer timer) {
      processLocationData();
    });
  }

  void processLocationData() async {
    locationInfo = await LocationHelper.getCurrentLocation();
    locationInfo?.deviceImeiNumber = (await DeviceIdHelper.getDeviceId())!;
    notifyListeners();
    sendLocationData();
  }

  Future<void> sendLocationData() async {
    // Perform HTTP request here
    try {
      String body = jsonEncode(locationInfo?.toJson());
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/tracking'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 201) {
        print('Sending data is successful.');
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending data: $error');
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
