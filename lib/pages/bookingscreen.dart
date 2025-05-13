import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final Map<String, dynamic> ride; // changed from List to Map
  const BookingScreen({super.key, required this.ride});
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
                    Text("${ride['time']}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("3h30", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    Text("22:00",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${ride['from']['city']}",
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
                    Text("${ride['to']['city']}",
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
                Text("\u20B9400.00",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading:
                CircleAvatar(radius: 24, backgroundColor: Colors.grey[300]),
            title:
                Text("Ramani", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Row(
              children: [
                Icon(Icons.verified, color: Colors.blue, size: 16),
                SizedBox(width: 4),
                Text("Verified Profile")
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
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
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: Icon(Icons.flash_on),
                label: Text("Request for Ride", style: TextStyle(fontSize: 16)),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
