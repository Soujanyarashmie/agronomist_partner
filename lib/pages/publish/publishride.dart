import 'dart:convert';
import 'package:agronomist_partner/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final uid = await userData.getFirebaseUid();
    const url = 'https://cloths-api-backend.onrender.com/api/v1/rides/publish'; // Replace with actual IP and port

    final body = {
      "uid": uid, // hardcoded user ID
      "from": {
        "city": fromController.text,
        "location": "Hardcoded From Street",
        "lat": 12.9716,
        "lng": 77.5946
      },
      "to": {
        "city": toController.text,
        "location": "Hardcoded To Place",
        "lat": 13.0827,
        "lng": 80.2707
      },
      "date": dateController.text,
      "time": timeController.text,
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
               const SizedBox(height: 20),
            Image.asset(
              'assets/images/noride.png', // your image path
              width: 180,
              height: 80,
              fit: BoxFit.contain,
            ),
              const SizedBox(height: 20),
              TextField(
                controller: fromController,
                decoration: const InputDecoration(
                  labelText: 'From',
                  hintText: 'City, town, address, or place',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: toController,
                decoration: const InputDecoration(
                  labelText: 'To',
                  hintText: 'City, town, address, or place',
                  border: OutlineInputBorder(),
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
                  prefixIcon: Icon(Icons.price_check),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Vechile Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.electric_bike),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: publishRide,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1B4EA0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Publish',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
