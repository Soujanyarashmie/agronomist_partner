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

  // Cache to store user data by uid
  Map<String, dynamic> userCache = {};

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

    print('Fetching rides for UID: $uid');
    print('Token: $token');
    print('GET Request URL: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          rides = data['rides'];
          loading = false;
        });
        print('Fetched ${rides.length} rides successfully.');
      } else {
        setState(() {
          errorMessage = "Failed to fetch rides";
          loading = false;
        });
        print('Error fetching rides: ${response.body}');
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred while fetching rides";
        loading = false;
      });
      print('Exception occurred: $e');
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

  Future<dynamic> fetchUserByUid(String uid) async {
    print('[DEBUG] fetchUserByUid called for uid: $uid');

    if (userCache.containsKey(uid)) {
      print('[DEBUG] Returning cached user data for uid: $uid');
      return userCache[uid];
    }

    final url = 'https://cloths-api-backend.onrender.com/api/v1/user/$uid';
    print('[DEBUG] Making HTTP GET request to: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG] Response status: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        print('[DEBUG] Successfully fetched user data for uid: $uid');
        userCache[uid] = userData;
        return userData;
      } else {
        print(
            '[ERROR] Failed to fetch user data for uid: $uid - Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('[ERROR] Exception while fetching user by uid $uid: $e');
      return null;
    }
  }

  Future<List<dynamic>> fetchConfirmedBookings() async {
    final token = await userData.getFirebaseToken() ?? '';
    debugPrint('🔑 Firebase Token: $token');

    final url = 'https://cloths-api-backend.onrender.com/api/v1/confirmed';
    debugPrint('📡 Sending GET request to: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('📥 Response Status: ${response.statusCode}');
    debugPrint('📥 Response Body123: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('✅ Confirmed bookings fetched: ${data['bookings'].length}');
      return data['bookings'];
    } else {
      debugPrint('❌ Failed to fetch confirmed bookings');
      throw Exception('Failed to fetch confirmed bookings');
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    print("Updating booking status...");
    print("Booking ID: $bookingId");
    print("New Status: $status");

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

  List<Widget> buildBookingRequestsWithRides() {
    List<Widget> widgets = [];

    // Group bookings by rideId
    Map<String, List<dynamic>> bookingsByRide = {};
    for (var booking in bookings) {
      var rideObj = booking['rideId'];
      if (rideObj == null) continue;
      String rideId = rideObj['_id'];
      if (!bookingsByRide.containsKey(rideId)) {
        bookingsByRide[rideId] = [];
      }
      bookingsByRide[rideId]!.add(booking);
    }

    if (rides.isEmpty) {
      widgets.add(Center(child: Text("No rides available")));
      return widgets;
    }

    for (var ride in rides) {
      final rideId = ride['_id'];

      if (bookingsByRide.containsKey(rideId)) {
        for (var booking in bookingsByRide[rideId]!) {
          final userId = booking['userId'] ?? '';
          final userFuture = fetchUserByUid(userId);

          widgets.add(
            FutureBuilder(
              future: userFuture,
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Center(child: CircularProgressIndicator());
                // }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Text("Failed to load user");
                } else {
                  final data = snapshot.data as Map<String, dynamic>;
                  final user = data['user'];

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TOP ROW
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(user['photoURL'] ?? ''),
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    user['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Date: ${booking['rideId']?['date']?.substring(0, 10) ?? 'N/A'}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// CITY ROW
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${ride['from']['city']}".toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Icon(Icons.compare_arrows),
                              Text(
                                "${ride['to']['city']}".toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(),

                          /// DETAILS ROW
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Status:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 4),
                                  Text('Booked By:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 4),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(booking['bookingStatus'] ?? 'pending',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Text(user['name'] ?? 'Unknown',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// ACTION BUTTONS or STATUS BAR
                          booking['bookingStatus'] == 'pending'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => updateBookingStatus(
                                          booking['_id'], 'cancelled'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: const Text("Reject"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => updateBookingStatus(
                                          booking['_id'], 'confirmed'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: const Text("Approve"),
                                    ),
                                  ],
                                )
                              : Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: BoxDecoration(
                                    color:
                                        booking['bookingStatus'] == 'confirmed'
                                            ? Colors.greenAccent[400]
                                            : Colors.redAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      booking['bookingStatus']
                                          .toString()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }
      } else {
        // No bookings for this ride
        widgets.add(Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              /// Top Row: Route & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(ride['from']['city'] ?? '').toString()} to ${(ride['to']['city'] ?? '').toString()}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Date : 12-5-15',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Middle Row: Cities and Arrows
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${ride['from']['city']}'.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.compare_arrows, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${ride['to']['city']}'.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Status Button
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "NO Request Yet",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      }
    }

    return widgets;
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
          // Tab 1: Confirmed Bookings
          FutureBuilder<List<dynamic>>(
            future: fetchConfirmedBookings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No confirmed bookings yet"));
              }

              final bookings = snapshot.data!;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final ride = booking['rideId'];

                  return Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("From: ${ride['from']['city']}"),
                        Text("To: ${ride['to']['city']}"),
                        Text("Date: ${ride['date'].substring(0, 10)}"),
                        Text("Seats Booked: ${booking['seatsBooked']}"),
                        Text("Status: ${booking['bookingStatus']}"),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          // Tab 2: Booking Requests
          ListView(
            padding: const EdgeInsets.all(12),
            children: buildBookingRequestsWithRides(),
          ),
        ],
      ),
    );
  }
}
