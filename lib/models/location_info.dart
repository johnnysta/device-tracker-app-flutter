class LocationInfo {
  String deviceImeiNumber;
  final double latitude;
  final double longitude;
  final DateTime dateTime;

  LocationInfo(
      {this.latitude = 0,
      this.longitude = 0,
      required this.dateTime,
      this.deviceImeiNumber = ''});

  Map<String, dynamic> toJson() {
    return {
      'deviceImeiNumber': deviceImeiNumber,
      'latitude': latitude,
      'longitude': longitude,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
