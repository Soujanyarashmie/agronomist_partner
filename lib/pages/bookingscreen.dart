import 'package:agronomist_partner/backend/go_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> ride;

  const BookingScreen({super.key, required this.ride});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String bookingStatus = "idle"; // idle, pending, confirmed, cancelled
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBookingStatus(); // check if ride is already booked
  }

  Future<void> requestRide(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final idToken = await user.getIdToken();
      final uri =
          Uri.parse('https://cloths-api-backend.onrender.com/api/v1/book');

      final requestBody = {
        "rideId": widget.ride['_id'],
        "seatsBooked": 1,
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: json.encode(requestBody),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ride booked successfully! 🎉")),
        );
        setState(() {
          bookingStatus = "pending";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Booking failed")),
        );
      }
    } catch (e) {
      print("🔴 Error during booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchBookingStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final idToken = await user.getIdToken();
      final uri = Uri.parse(
          'https://cloths-api-backend.onrender.com/api/v1/bookings?rideId=${widget.ride['_id']}');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['booking'] != null &&
            data['booking']['bookingStatus'] != null) {
          setState(() {
            bookingStatus = data['booking']
                ['bookingStatus']; // pending / confirmed / cancelled
          });
        }
      }
    } catch (e) {
      print("🔴 Error fetching booking status: $e");
    }
  }

  String getButtonLabel() {
    switch (bookingStatus) {
      case "pending":
        return "Booking Pending...";
      case "confirmed":
        return "Booking Confirmed 🎉";
      case "cancelled":
        return "Booking Cancelled ❌";
      case "idle":
      default:
        return "Request for Ride";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text("Tuesday, 13 May",
            style: TextStyle(fontSize: 24, color: Colors.black)),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.ride['startTime']}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("3h30", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                   Text("${widget.ride['endTime']}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.ride['from']['city']}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        "2nd Floor, 30/6, Hosur Rd, nr. Trident Tech Park, Muneswara Nagar, Sector 6, HSR Layout, Kar...",
                        style: TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("${widget.ride['to']['city']}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        "4, 5 Rd, SIDCO Industrial Estate, Swarnapuri, Tamil Nadu",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("passenger",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("₹${widget.ride['pricePerSeat']}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              backgroundImage: widget.ride['user'] != null &&
                      widget.ride['user']['photoURL'] != null
                  ? NetworkImage(widget.ride['user']['photoURL'])
                  : null,
              child: widget.ride['user'] == null ||
                      widget.ride['user']['photoURL'] == null
                  ? Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            title: Text(
              widget.ride['user']?['name'] ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: const [
                Icon(Icons.verified, color: Colors.blue, size: 16),
                SizedBox(width: 4),
                Text("Verified Profile"),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.push('/ownerprofile', extra: widget.ride);
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.flash_on, size: 20, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                        child:
                            Text("Your booking will be confirmed instantly")),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.smoke_free, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text("No smoking, please"),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.pets_outlined, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(child: Text("I’d prefer not to travel with pets")),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: bookingStatus == "confirmed"
                      ? Colors.green
                      : bookingStatus == "cancelled"
                          ? Colors.red
                          : Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(Icons.flash_on),
                label: isLoading
                    ? Text("Booking...", style: TextStyle(fontSize: 16))
                    : Text(getButtonLabel(), style: TextStyle(fontSize: 16)),
                onPressed: bookingStatus == "idle" && !isLoading
                    ? () => requestRide(context)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
