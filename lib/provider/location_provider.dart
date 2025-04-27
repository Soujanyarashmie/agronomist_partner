import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  // Main page locations
  String _mainFromLocation = "Select Location";
  double _mainFromLat = 0.0;
  double _mainFromLng = 0.0;
  
  String _mainToLocation = "Select Location";
  double _mainToLat = 0.0;
  double _mainToLng = 0.0;

  // Publish page locations
  String _publishFromLocation = "Select Location";
  double _publishFromLat = 0.0;
  double _publishFromLng = 0.0;
  
  String _publishToLocation = "Select Location";
  double _publishToLat = 0.0;
  double _publishToLng = 0.0;

  // Getters for main page
  String get mainFromLocation => _mainFromLocation;
  double get mainFromLat => _mainFromLat;
  double get mainFromLng => _mainFromLng;
  
  String get mainToLocation => _mainToLocation;
  double get mainToLat => _mainToLat;
  double get mainToLng => _mainToLng;

  // Getters for publish page
  String get publishFromLocation => _publishFromLocation;
  double get publishFromLat => _publishFromLat;
  double get publishFromLng => _publishFromLng;
  
  String get publishToLocation => _publishToLocation;
  double get publishToLat => _publishToLat;
  double get publishToLng => _publishToLng;

  // Update methods for main page
  void updateMainFromLocation(String locality, double lat, double lng) {
    _mainFromLocation = locality;
    _mainFromLat = lat;
    _mainFromLng = lng;
    notifyListeners();
  }

  void updateMainToLocation(String locality, double lat, double lng) {
    _mainToLocation = locality;
    _mainToLat = lat;
    _mainToLng = lng;
    notifyListeners();
  }

  // Update methods for publish page
  void updatePublishFromLocation(String locality, double lat, double lng) {
    _publishFromLocation = locality;
    _publishFromLat = lat;
    _publishFromLng = lng;
    notifyListeners();
  }

  void updatePublishToLocation(String locality, double lat, double lng) {
    _publishToLocation = locality;
    _publishToLat = lat;
    _publishToLng = lng;
    notifyListeners();
  }

  // Method to trigger price update when locations change
  void triggerPriceUpdate() {
    // You can place logic here to check if both locations are set
    if (_publishFromLocation != "Select Location" && _publishToLocation != "Select Location") {
      notifyListeners();
    }
  }
}
