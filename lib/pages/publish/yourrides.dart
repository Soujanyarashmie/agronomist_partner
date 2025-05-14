import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:agronomist_partner/pages/login.dart'; // for UserData
import 'package:agronomist_partner/pages/noridepublish.dart'; // for CenterImageWithTopText

class DriverRidesTabsPage extends StatefulWidget {
  @override
  _DriverRidesTabsPageState createState() => _DriverRidesTabsPageState();
}

class _DriverRidesTabsPageState extends State<DriverRidesTabsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UserData userData = UserData();

  String token = '';
  String uid = '';
  bool loading = true;
  String errorMessage = '';
  List<dynamic> rides = [];
  List<dynamic> bookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    initData();
  }

  Future<void> initData() async {
    print('[DEBUG] Initializing data...');
    try {
      token = await userData.getFirebaseToken() ?? '';
      uid = await userData.getFirebaseUid() ?? '';
      print('[DEBUG] Retrieved token: $token');
      print('[DEBUG] Retrieved uid: $uid');

      if (token.isEmpty || uid.isEmpty) {
        print('[ERROR] Token or UID is missing');
        setState(() {
          errorMessage = "Token or UID missing";
          loading = false;
        });
        return;
      }

      await fetchMyRides();
      await fetchDriverBookings();
    } catch (e) {
      print('[ERROR] Exception in initData: $e');
      setState(() {
        errorMessage = e.toString();
        loading = false;
      });
    }
  }

  Future<void> fetchMyRides() async {
    final url =
        'https://cloths-api-backend.onrender.com/api/v1/rides/myrides?uid=$uid';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        rides = data['rides'];
        loading = false;
      });
    } else {
      setState(() {
        errorMessage = "Failed to fetch rides";
        loading = false;
      });
    }
  }

  Future<void> fetchDriverBookings() async {
    final url =
        'https://cloths-api-backend.onrender.com/api/v1/driver/bookings';
    print('[DEBUG] Fetching bookings for driver...');
    print('[DEBUG] UID: $uid');
    print('[DEBUG] Token: $token');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG] Status Code: ${response.statusCode}');
      print('[DEBUG] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[DEBUG] Bookings fetched: ${data['bookings'].length}');
        setState(() {
          bookings = data['bookings'];
          loading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to fetch bookings";
          loading = false;
        });
      }
    } catch (e) {
      print('[ERROR] Exception during fetchDriverBookings: $e');
      setState(() {
        errorMessage = "Error: $e";
        loading = false;
      });
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    print("Updating booking status...");
    print("Booking ID: $bookingId");
    print("New Status: $status");

    // Correct URL with /api/v1/
    final url =
        'https://cloths-api-backend.onrender.com/api/v1/booking/$bookingId';
    print("API URL: $url");
    print("Token: $token");

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'bookingStatus': status}),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Booking $status')));
      await fetchDriverBookings();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update booking')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    if (errorMessage.isNotEmpty)
      return Scaffold(body: Center(child: Text(errorMessage)));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('My Rides & Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Your Rides'),
            Tab(text: 'Booking Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          /// === Tab 1: Your Rides ===
          rides.isEmpty
              ? CenterImageWithTopText()
              : ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    final ride = rides[index];
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text('From: ${ride['from']['city']}'),
                        subtitle: Text('To: ${ride['to']['city']}'),
                        trailing: Text('${ride['seatsAvailable']} seats'),
                      ),
                    );
                  },
                ),

          /// === Tab 2: Booking Requests ===
          bookings.isEmpty
              ? Center(child: Text("No booking requests yet"))
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final ride = booking['rideId'];
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                            "Ride to ${ride['to']['city']} (${ride['date']})"),
                        subtitle: Text(
                            "Seats Booked: ${booking['seatsBooked']}\nStatus: ${booking['bookingStatus']}"),
                        trailing: booking['bookingStatus'] == 'pending'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () => updateBookingStatus(
                                        booking['_id'], 'confirmed'),
                                    child: Text("Approve",
                                        style: TextStyle(color: Colors.green)),
                                  ),
                                  TextButton(
                                    onPressed: () => updateBookingStatus(
                                        booking['_id'], 'cancelled'),
                                    child: Text("Reject",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              )
                            : Text(
                                booking['bookingStatus'].toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
