import 'dart:convert';
import 'package:agronomist_partner/pages/login.dart';
import 'package:agronomist_partner/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
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

  bool onlyFromRegulars = false;
  bool notifyMatchingRides = false;

  int currentIndex = 0;

  Future<void> publishRide() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    double fromLat = locationProvider.publishFromLat;
    double fromLng = locationProvider.publishFromLng;
    double toLat = locationProvider.publishToLat;
    double toLng = locationProvider.publishToLng;
    String publishFromLocation = locationProvider.publishFromLocation;
    String publishToLocation = locationProvider.publishToLocation;
    final uid = await userData.getFirebaseUid();
    const url =
        'https://cloths-api-backend.onrender.com/api/v1/rides/publish'; // Replace with actual IP and port

    final body = {
      "uid": uid,
      "from": {
        "city": publishFromLocation,
        "location": "Hardcoded From Street",
        "lat": fromLat,
        "lng": fromLng
      },
      "to": {
        "city": publishToLocation,
        "location": "Hardcoded To Place",
        "lat": toLat,
        "lng": toLng
      },
      "date": dateController.text,
      "startTime": timeController.text,
      "endTime": "7.30pm",
      "seatsAvailable": 3,
      "pricePerSeat": double.tryParse(priceController.text) ?? 0,
      "vehicleDetails": {
        "type": typeController.text,
        "plateNumber": numberController.text
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride published successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to publish: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> getApproxPrice() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    double fromLat = locationProvider.publishFromLat;
    double fromLng = locationProvider.publishFromLng;
    double toLat = locationProvider.publishToLat;
    double toLng = locationProvider.publishToLng;

    final url =
        'https://cloths-api-backend.onrender.com/api/v1/calculate-price'; // Replace with your actual endpoint

    final body = {
      'fromLat': fromLat,
      'fromLon': fromLng,
      'toLat': toLat,
      'toLon': toLng,
    };

    print(
        'Request body: $body'); // Debug: Print the body to check the data sent

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print(
          'Response status: ${response.statusCode}'); // Debug: Print the status code
      print(
          'Response body: ${response.body}'); // Debug: Print the body of the response

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('API Response: $data'); // Debug: Print the parsed response data

        if (data['price'] != null) {
          print(
              'Price from API: ${data['price']}'); // Debug: Print the price value
          setState(() {
            priceController.text = data['price'].toString();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Price calculated successfully!')),
          );
        } else {
          print('Price not found in response'); // Debug: If no price is found
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Price not found in response')),
          );
        }
      } else {
        print(
            'Failed API call: ${response.statusCode}'); // Debug: If status code is not 200/201
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to calculate price: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error: $e'); // Debug: Print any error that occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
        getApproxPrice(); // Call the API when locations are set
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
              const Text(
                'Where to?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.42,
                left: 20,
                right: 20,
                child: Container(
                  height: 153,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final result = await context.push('/mapPicker',
                              extra: {'isFrompublishLocation': true});
                          if (result != null &&
                              result is Map<String, dynamic>) {
                            Provider.of<LocationProvider>(context,
                                    listen: false)
                                .updatePublishFromLocation(
                              result['locality'] ?? "Select Location",
                              result['latitude'] ?? 0.0,
                              result['longitude'] ?? 0.0,
                            );
                          }
                        },
                        child: Consumer<LocationProvider>(
                            builder: (context, locationProvider, child) {
                          return Container(
                            height: 47,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/images/from.png',
                                    width: 24),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("FROM:",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey)),
                                    const SizedBox(height: 2),
                                    Text(
                                      locationProvider.publishFromLocation,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final result = await context.push('/mapPicker',
                              extra: {'isToPublishLocation': true});
                          if (result != null &&
                              result is Map<String, dynamic>) {
                            Provider.of<LocationProvider>(context,
                                    listen: false)
                                .updatePublishToLocation(
                              result['locality'] ?? "Select Location",
                              result['latitude'] ?? 0.0,
                              result['longitude'] ?? 0.0,
                            );
                          }
                        },
                        child: Consumer<LocationProvider>(
                            builder: (context, locationProvider, child) {
                          return Container(
                            height: 47,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/images/to.png', width: 24),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("TO:",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey)),
                                    const SizedBox(height: 2),
                                    Text(
                                      locationProvider.publishToLocation,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Departure date (optional)',
                  hintText: 'MM/DD',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
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
