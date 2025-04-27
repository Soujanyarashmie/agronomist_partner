import 'package:agronomist_partner/pages/searchpage.dart';
import 'package:agronomist_partner/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import 'package:geocoding/geocoding.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:location/location.dart';
import 'package:provider/provider.dart';

class AddressManager {
  // Private Constructor
  AddressManager._privateConstructor();

  // Singleton Instance
  static final AddressManager _instance = AddressManager._privateConstructor();

  // Getter for Singleton Instance
  static AddressManager get instance => _instance;

  // Address fields
  String? fullAddress;
  String? locality; // City
  String? administrativeArea; // State
  String? postalCode; // Pincode
  String? subLocality; // Area
  String? country;

  /// Update Address Information
  void updateAddress(
      {required String fullAddress,
      required String locality,
      required String administrativeArea,
      required String postalCode,
      required String subLocality,
      required String country}) {
    this.fullAddress = fullAddress;
    this.locality = locality;
    this.administrativeArea = administrativeArea;
    this.postalCode = postalCode;
    this.subLocality = subLocality;
    this.country = country;
  }

  /// Clear Address Information
  void clearAddress() {
    fullAddress = null;
    locality = null;
    administrativeArea = null;
    postalCode = null;
    subLocality = null;
    country = null;
  }

  /// Get Specific Address Details
  String getFullAddress() => fullAddress ?? "Unknown Address";
  String getLocality() => locality ?? "Unknown City";
  String getAdministrativeArea() => administrativeArea ?? "Unknown State";
  String getPostalCode() => postalCode ?? "Unknown Pincode";
  String getSubLocality() => subLocality ?? "Unknown Area";
  String getCountry() => country ?? "Unknown Country";
}

class GoogleMapLocationPicker extends StatefulWidget {
  final ValueChanged<String>? onAddressChanged;
  final bool isFromLocation; // Add this line
  final bool isToPublishLocation;
  final bool isFrompublishLocation;
  const GoogleMapLocationPicker(
      {super.key,
      this.width,
      this.height,
      this.initialCamera,
      this.initialZoom,
      this.onAddressChanged,
      required this.isFromLocation,
      required this.isToPublishLocation,
      required this.isFrompublishLocation});

  final double? width;
  final double? height;
  final LatLng? initialCamera;
  final int? initialZoom;

  @override
  _GoogleMapLocationPickerState createState() =>
      _GoogleMapLocationPickerState();
}

class _GoogleMapLocationPickerState extends State<GoogleMapLocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _lastMapPosition;
  String _address = "Fetching location...";
  String _currentAdress = "Fetching location...";
  final TextEditingController _searchController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();
  LatLng? _initialCameraPosition;
  String? locality;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation(); // Ensuring this is called at the start.
  }

  Future<void> _fetchCurrentLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() => _address = "Location service is disabled");
        return;
      }
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        setState(() => _address = "Location permission denied");
        return;
      }
    }

    final locData = await location.getLocation();
    LatLng currentPosition = LatLng(locData.latitude!, locData.longitude!);
    _updateMapPosition(currentPosition);
  }

  /// Fetch the address of a given latitude and longitude.
  Future<void> _fetchAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String fullAddress =
            "${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";

        // Update AddressManager with fetched data
        AddressManager.instance.updateAddress(
          fullAddress: fullAddress,
          locality: place.locality ?? "Unknown City",
          administrativeArea: place.administrativeArea ?? "Unknown State",
          postalCode: place.postalCode ?? "Unknown Pincode",
          subLocality: place.subLocality ?? "Unknown Area",
          country: place.country ?? "Unknown Country",
        );

        // Store the administrativeArea to use later
        locality = place.locality ?? "Unknown State";

        setState(() {
          _address = fullAddress;
          _currentAdress = place.name ?? "Unknown location";
        });
      }
    } catch (e) {
      setState(() {
        _address = "location loading";
        _currentAdress = "Unknown location";
      });
      print("Error fetching address: $e");
    }
  }

  /// Called when the map is created, initializing the position.
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fetchCurrentLocation().then((_) {
      if (_lastMapPosition != null) {
        _updateMapPosition(_lastMapPosition!);
      }
    });
  }

  /// Updates the map position when the camera moves.
  void _onCameraMove(CameraPosition position) {
    _lastMapPosition =
        LatLng(position.target.latitude, position.target.longitude);
  }

  /// Updates the address when the camera stops moving.
  Future<void> _onCameraIdle() async {
    if (_lastMapPosition != null) {
      _fetchAddress(_lastMapPosition!.latitude, _lastMapPosition!.longitude);

      // Store the latitude and longitude in secure storage
      await _secureStorage.write(
          key: 'latitude', value: _lastMapPosition!.latitude.toString());
      await _secureStorage.write(
          key: 'longitude', value: _lastMapPosition!.longitude.toString());
      print('latitude:${_lastMapPosition!.latitude}');
      print('longitude:${_lastMapPosition!.longitude}');
      if (widget.onAddressChanged != null) {
        widget.onAddressChanged!(_address);
      }
    }
  }

  void _updateMapPosition(LatLng position) {
    _mapController?.moveCamera(CameraUpdate.newLatLngZoom(
        position, 15)); // Ensure zoom level is adequate
    setState(() {
      _lastMapPosition = position;
      _address = "Fetching address...";
    });
    _fetchAddress(position.latitude, position.longitude);
  }

  /// Fetch location suggestions using Google Places API
  Future<List<String>> _fetchLocationSuggestions(String query) async {
    if (query.isEmpty) return [];

    try {
      // API URL for Places Autocomplete
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyCldpuL58Agx_mdcfZ-lPZ9YHhRCe8TzrM');

      // Make the HTTP request
      final response = await http.get(url);

      // Check response status
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract predictions and return descriptions
        return (data['predictions'] as List)
            .map((item) => item['description'] as String)
            .toList();
      } else {
        print("Error fetching suggestions: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
      return [];
    }
  }

  /// Handle suggestion selection and fetch coordinates
  void _onSuggestionSelected(String suggestion) async {
    try {
      // API URL for Geocoding
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$suggestion&key=AIzaSyCldpuL58Agx_mdcfZ-lPZ9YHhRCe8TzrM');

      // Make the HTTP request
      final response = await http.get(url);

      // Check response status
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract latitude and longitude
        final location = data['results'][0]['geometry']['location'];
        final LatLng selectedLocation =
            LatLng(location['lat'], location['lng']);

        // Update map position and fetch address
        _updateMapPosition(selectedLocation);
        _fetchAddress(selectedLocation.latitude, selectedLocation.longitude);
      } else {
        print("Error fetching coordinates: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching coordinates: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map Widget
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _initialCameraPosition ?? const LatLng(0.0, 0.0),
            zoom: widget.initialZoom?.toDouble() ?? 14.0,
          ),
          onCameraMove: _onCameraMove,
          onCameraIdle: _onCameraIdle,
          mapType: MapType.normal,
        ),

        //Center Marker Icon
        Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40.0, // Adjust size as needed
          ),
        ),

        // Search Bar
        Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Color.fromRGBO(87, 99, 108, 100),
                              size: 24),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        // Expanded(
                        //   child: Container(
                        //     height: 50,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(8),
                        //       border: Border.all(color: Colors.grey),
                        //     ),
                        //     child: TypeAheadField<String>(
                        //       textFieldConfiguration: TextFieldConfiguration(
                        //         controller: _searchController,
                        //         decoration: InputDecoration(
                        //           hintText: 'Search',
                        //           hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                        //           border: InputBorder.none,
                        //           prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        //           contentPadding: const EdgeInsets.symmetric(
                        //             vertical: 12.0, // Center the hint text vertically
                        //           ),
                        //         ),
                        //       ),
                        //       suggestionsCallback: _fetchLocationSuggestions,
                        //       itemBuilder: (context, suggestion) {
                        //         return ListTile(
                        //           title: Text(suggestion),
                        //         );
                        //       },
                        //       // onSuggestionSelected: (suggestion) {
                        //       //   _onSuggestionSelected(suggestion);
                        //       //   _searchController.text = suggestion;
                        //       // },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Address and Select Button
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 250,
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_lastMapPosition != null) {
                      final Map<String, dynamic> locationData = {
                        'latitude': _lastMapPosition!.latitude,
                        'longitude': _lastMapPosition!.longitude,
                        'address': _address,
                        'locality': locality ??
                            "Unknown State", // Using class-level locality
                      };

                      // Extract values with proper type casting and distinct names
                      final String selectedLocality =
                          locationData['locality'] as String;
                      final double selectedLatitude =
                          locationData['latitude'] as double;
                      final double selectedLongitude =
                          locationData['longitude'] as double;

                      // Determine which field to update based on the flags
                      if (widget.isFromLocation) {
                        Provider.of<LocationProvider>(context, listen: false)
                            .updateMainFromLocation(
                          selectedLocality,
                          selectedLatitude,
                          selectedLongitude,
                        );
                      } else if (widget.isToPublishLocation) {
                        Provider.of<LocationProvider>(context, listen: false)
                            .updatePublishToLocation(
                          selectedLocality,
                          selectedLatitude,
                          selectedLongitude,
                        );
                      } else if (widget.isFrompublishLocation) {
                        Provider.of<LocationProvider>(context, listen: false)
                            .updatePublishFromLocation(
                          selectedLocality,
                          selectedLatitude,
                          selectedLongitude,
                        );
                      } else {
                        Provider.of<LocationProvider>(context, listen: false)
                            .updateMainToLocation(
                          selectedLocality,
                          selectedLatitude,
                          selectedLongitude,
                        );
                      }

                      Navigator.pop(context, locationData);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Select Location'),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
