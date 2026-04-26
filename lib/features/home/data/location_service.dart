import 'dart:developer';

import 'package:geocoding/geocoding.dart' show placemarkFromCoordinates;
import 'package:location/location.dart';

class LocationService {
  Future<String> requestPermissionsAndResolveCity() async {
    final location = Location();
    log("avi location service");
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    if (!serviceEnabled) {
      return 'Location Off';
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted != PermissionStatus.granted) {
      return 'Permission Needed';
    }

    final locationData = await location.getLocation();
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;
    if (latitude == null || longitude == null) {
      return 'Unknown';
    }

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
