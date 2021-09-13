import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bluesky_project/services/geolocator_service.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  final geoLocatorService = GeoLocatorService();

  LocationData location;
  Position currentLocation;

  LocationProvider() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }
}