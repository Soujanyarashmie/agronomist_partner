import 'package:agronomist_partner/provider/map_selector_mode.dart';
import 'package:flutter/material.dart';
// Assuming AddressCreationMapInformation is defined elsewhere, adjust import if needed

class MapSelectionProvider extends ChangeNotifier {
  AddressCreationMapInformation? _selectedMapInfo;

  AddressCreationMapInformation? get selectedMapInfo => _selectedMapInfo;

  void updateMapInfo(AddressCreationMapInformation? newInfo) {
    // Optional: Check if the value actually changed to avoid unnecessary notifications
    if (_selectedMapInfo?.latitude != newInfo?.latitude ||
        _selectedMapInfo?.longitude != newInfo?.longitude ||
        _selectedMapInfo?.addressLine1 != newInfo?.addressLine1) {
      _selectedMapInfo = newInfo;
      notifyListeners(); // Notify widgets listening to this provider
      print(
          "MapSelectionProvider updated: ${newInfo?.addressLine1}"); // Debug print
    }
  }

  // Optional: Method to clear the selectiona
  void clearMapInfo() {
    if (_selectedMapInfo != null) {
      _selectedMapInfo = null;
      notifyListeners();
    }
  }
}
