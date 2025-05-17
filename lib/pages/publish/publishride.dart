import 'dart:convert';
import 'package:agronomist_partner/pages/login.dart';
import 'package:agronomist_partner/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PublishRidePage extends StatefulWidget {
  const PublishRidePage({Key? key}) : super(key: key);

  @override
  State<PublishRidePage> createState() => _PublishRidePageState();
}

class _PublishRidePageState extends State<PublishRidePage> {
  final UserData userData = UserData();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController endtimeController = TextEditingController();
  String formattedBackendDate = '';

  bool onlyFromRegulars = false;
  bool notifyMatchingRides = false;

  int currentIndex = 0;

  Future<void> publishRide() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final token = await userData.getFirebaseToken(); // Get auth token

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication required')),
      );
      return;
    }

    try {
      final body = {
        "uid": await userData.getFirebaseUid(),
        "from": {
          "city": locationProvider.publishFromLocation,
          "location": "From Location", // You might want to make this dynamic
          "lat": locationProvider.publishFromLat,
          "lng": locationProvider.publishFromLng
        },
        "to": {
          "city": locationProvider.publishToLocation,
          "location": "To Location", // You might want to make this dynamic
          "lat": locationProvider.publishToLat,
          "lng": locationProvider.publishToLng
        },
        "date": formattedBackendDate,
        "startTime": timeController.text,
        "endTime": endtimeController.text, // Fixed: using .text
        "seatsAvailable": int.tryParse(numberController.text) ??
            1, // Assuming seats is from numberController
        "pricePerSeat": double.tryParse(priceController.text) ?? 0.0,
        "vehicleDetails": {
          "type": typeController.text,
          "plateNumber": numberController.text
        }
      };

      print('Request body: ${jsonEncode(body)}'); // Debug logging

      final response = await http.post(
        Uri.parse(
            'https://cloths-api-backend.onrender.com/api/v1/rides/publish'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Added auth header
        },
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride published successfully!')),
        );
        // Clear form after successful submission
        _clearForm();
      } else {
        final errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to publish: ${errorResponse['message'] ?? response.body}')),
        );
      }
    } catch (e) {
      print('Error publishing ride: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _clearForm() {
    fromController.clear();
    toController.clear();
    dateController.clear();
    timeController.clear();
    endtimeController.clear();
    priceController.clear();
    typeController.clear();
    numberController.clear();
    formattedBackendDate = '';

    // Clear location provider values
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.updatePublishFromLocation("Select Location", 0.0, 0.0);
    locationProvider.updatePublishToLocation("Select Location", 0.0, 0.0);
  }

  @override
  void initState() {
    super.initState();

    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.addListener(() {
      print(
          'Location provider updated'); // Print when the location provider is updated
      print('From location: ${locationProvider.publishFromLocation}');
      print('To location: ${locationProvider.publishToLocation}');

      if (locationProvider.publishFromLocation != "Select Location" &&
          locationProvider.publishToLocation != "Select Location") {
        print('Both locations are selected, calling getApproxPrice...');
        //  getApproxPrice(); // Call the API when locations are set
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    // Display format: dd-MM-yyyy
                    String displayDate =
                        DateFormat('dd-MM-yyyy').format(picked);
                    dateController.text = displayDate;

                    // Store backend format separately if needed
                    formattedBackendDate =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Departure date',
                      hintText: 'dd-MM-yyyy',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: endtimeController,
                decoration: const InputDecoration(
                  labelText: 'Time ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_car_wash),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: publishRide,
                child: const Text('Publish Ride'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
