import 'package:agronomist_partner/pages/login.dart';
import 'package:agronomist_partner/pages/noridepublish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YourRidespage extends StatefulWidget {
  @override
  _YourRidesPageState createState() => _YourRidesPageState();
}

class _YourRidesPageState extends State<YourRidespage> {
  List<dynamic> rides = [];
  bool isLoading = true;
  String errorMessage = '';
  final UserData userData = UserData();

  // Fetch rides based on UID and Firebase token
Future<void> fetchMyRides() async {
  try {
    final firebaseToken = await userData.getFirebaseToken();
    print("🔐 Firebase Token: $firebaseToken");

    if (firebaseToken == null || firebaseToken.isEmpty) {
      setState(() {
        errorMessage = 'No Firebase token found.';
        isLoading = false;
      });
      print("❌ No Firebase token found");
      return;
    }

    final uid = await userData.getFirebaseUid();
    print("👤 Firebase UID: $uid");

    final url = 'https://cloths-api-backend.onrender.com/api/v1/rides/myrides?uid=$uid';
    print("🌍 Request URL: $url");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $firebaseToken',
      },
    );

    print("📡 Response status: ${response.statusCode}");
    print("📦 Response body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print("✅ Parsed JSON: $jsonBody");

      final fetchedRides = jsonBody['rides'];
      print("🚗 Total rides fetched: ${fetchedRides.length}");

      setState(() {
        rides = fetchedRides;
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = 'Failed to load rides: ${response.body}';
        isLoading = false;
      });
      print("❌ Failed to fetch rides");
    }
  } catch (error) {
    setState(() {
      errorMessage = 'An error occurred: $error';
      isLoading = false;
    });
    print("❌ Error during fetch: $error");
  }
}

  @override
  void initState() {
    super.initState();
    fetchMyRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : rides.isEmpty
                  ? CenterImageWithTopText()
                  : ListView.builder(
                      itemCount: rides.length,
                      itemBuilder: (context, index) {
                        final ride = rides[index];
                        return ListTile(
                          title: Text('From: ${ride['from']['city']}'),
                          subtitle: Text('To: ${ride['to']['city']}'),
                          trailing:
                              Text('${ride['seatsAvailable']} seats available'),
                        );
                      },
                    ),
    );
  }
  
}
