import 'package:device_tracker_app/models/location_info.dart';
import 'package:location/location.dart';

class LocationHelper {
  static Future<LocationInfo?> getCurrentLocation() async {
    try {
      final locData = await Location().getLocation();
      print("Latitude:  $locData.latitude");
      print("Longitude:  $locData.longitude");
      double? latitude = locData.latitude;
      double? longitude = locData.longitude;
      print("Latitude2:  $latitude");
      print("Longitude2:  $longitude");
      if (latitude != null && longitude != null) {
        LocationInfo locationInfo = LocationInfo(
          latitude: latitude,
          longitude: longitude,
          dateTime: DateTime.now(),
        );
        return locationInfo;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
