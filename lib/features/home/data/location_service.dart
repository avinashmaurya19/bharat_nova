import 'dart:developer';

import 'package:geocoding/geocoding.dart' show placemarkFromCoordinates;
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<String> requestPermissionsAndResolveCity() async {
    log("avi location service");
    var permissionGranted = await Geolocator.checkPermission();
    if (permissionGranted == LocationPermission.denied) {
      permissionGranted = await Geolocator.requestPermission();
    }
    if (permissionGranted == LocationPermission.denied) {
      return 'Permission Needed';
    }
    if (permissionGranted == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return 'Permission Needed';
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return 'Location Off';
    }

    final locationData = await Geolocator.getCurrentPosition();
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    final places = await placemarkFromCoordinates(latitude, longitude);

    if (places.isEmpty) {
      return 'Unknown';
    }

    final city = places.first.locality?.trim();
    if (city == null || city.isEmpty) {
      return places.first.subAdministrativeArea ?? 'Unknown';
    }

    return city;
  }
}
