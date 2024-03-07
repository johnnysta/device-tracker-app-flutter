class SettingsInfo {
  int meteringFrequency;
  bool isGeofenceActive;
  double geofenceCenterLatitude;
  double geofenceCenterLongitude;
  int geofenceRadius;

  SettingsInfo(
      {this.meteringFrequency = 5,
      this.isGeofenceActive = false,
      this.geofenceCenterLatitude = 0,
      this.geofenceCenterLongitude = 0,
      this.geofenceRadius = 0});

  setFrequency(int f) {
    this.meteringFrequency = f;
  }
}
