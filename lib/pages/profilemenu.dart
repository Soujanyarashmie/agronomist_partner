import 'package:agronomist_partner/pages/login.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double avatarRadius = 50;
    final double appBarHeight = 150;
    final UserData userData = UserData(); 

    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: appBarHeight,
                padding: const EdgeInsets.only(top: 28.0),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  centerTitle: true,
  title: Container(), // Remove text from here to position it manually
  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pop(context),
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.settings, color: Colors.white),
      onPressed: () {
        // Settings action
      },
    ),
  ],
  flexibleSpace: LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: constraints.biggest.height / 2 - 28, // Adjust top position to move text up
            child: Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15, // Optional: Adjust font size if needed
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  ),
),


              ),
              SizedBox(height: 60),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      userData.name, 
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Edit profile action
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, 
                        backgroundColor: Colors.green[400],
                      ),
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: appBarHeight - avatarRadius, // Position to straddle the AppBar and body
            left: MediaQuery.of(context).size.width / 2 - avatarRadius,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2), // Outer circle border
              ),
              padding: const EdgeInsets.all(2), // Adjust the spacing for the border
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundImage: NetworkImage(userData.imageUrl), // Replace with actual image URL
              ),
            ),
          ),
        ],
      ),
    );
  }
}
