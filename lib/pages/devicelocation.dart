import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeviceLocation {
  final Location _location = Location();

  // Function to check location service and permission
  Future<bool> checkLocationPermission() async {
    // Check if service is enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        print("Location service is not enabled.");
        return false;
      }
    }

    // Check permission
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission not granted.");
        return false;
      }
    }

    print("Location permission granted.");
    return true;
  }

  // Function to fetch the current location
  Future<LatLng?> getCurrentLocation() async {
    bool hasPermission = await checkLocationPermission();
    if (!hasPermission) {
      return null;
    }

    final locationData = await _location.getLocation();
    print("Fetched current location: ${locationData.latitude}, ${locationData.longitude}");
    
    if (locationData.latitude != null && locationData.longitude != null) {
      return LatLng(locationData.latitude!, locationData.longitude!);
    } else {
      print("Failed to fetch valid location coordinates.");
      return null;
    }
  }
}
