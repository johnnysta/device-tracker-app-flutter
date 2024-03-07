import 'dart:async';

import 'package:device_tracker_app/helpers/device_id_helper.dart';
import 'package:device_tracker_app/helpers/location_helper.dart';
import 'package:device_tracker_app/models/location_info.dart';
import 'package:device_tracker_app/models/settings_info.dart';
import 'package:device_tracker_app/providers/location_provider.dart';
import 'package:device_tracker_app/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:device_imei/device_imei.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SettingsProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, LocationProvider>(
            update: (ctx, settingsProvider, previousLocationProvider) =>
                previousLocationProvider!.update(settingsProvider.settings),
            create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        title: 'Device Tracker',
        theme: ThemeData(primarySwatch: Colors.amber),
        home: MyHomePage(title: 'Device Tracker Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String deviceId;

  @override
  void initState() {
    super.initState();
    initializeDeviceId();
    Provider.of<SettingsProvider>(context, listen: false).startTimer();
    //Provider.of<LocationProvider>(context, listen: false).startTimer();
  }

  Future<void> initializeDeviceId() async {
    deviceId =
        await DeviceIdHelper.getDeviceId() ?? ''; // Use default value if null
    // No need to call setState since deviceId doesn't change after initialization
  }

  @override
  void dispose() {
    // Stop the timer when the widget is disposed
    Provider.of<LocationProvider>(context, listen: false).stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Location info:',
            ),
            Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'Device ID: ${locationProvider.locationInfo!.deviceImeiNumber}'),
                    Text(
                        'Latitude: ${locationProvider.locationInfo!.latitude}'),
                    Text(
                        'Longitude: ${locationProvider.locationInfo!.longitude}'),
                    Text('Time: ${locationProvider.locationInfo!.dateTime}'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
