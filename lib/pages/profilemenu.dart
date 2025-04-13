import 'package:agronomist_partner/backend/go_router.dart';
import 'package:agronomist_partner/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double avatarRadius = 50;
    final double appBarHeight = 150;
    final UserData userData = UserData();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // AppBar with profile title
              Container(
                height: appBarHeight,
                padding: const EdgeInsets.only(top: 28.0),
                decoration: BoxDecoration(
                  color: Color(0xFF1B4EA0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: AppBar(
                  backgroundColor: Color(0xFF1B4EA0),
                  elevation: 0,
                  centerTitle: true,
                  title: Container(),
                  // leading: IconButton(
                  //   icon: Icon(Icons.arrow_back, color: Colors.white),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        // Settings action
                      },
                    ),
                  ],
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: constraints.biggest.height / 2 - 28,
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
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
              // Profile info and Edit Profile button
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
                        context.push('/editprofile');
                        // Edit profile action
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF1B4EA0),
                      ),
                      child: Text('Edit Profile'),
                    ),
                    SizedBox(height: 30),
                    // Account Information List
                    buildAccountInfoList(context),
                  ],
                ),
              ),
            ],
          ),
          // Positioned profile avatar
          Positioned(
            top: appBarHeight - avatarRadius,
            left: MediaQuery.of(context).size.width / 2 - avatarRadius,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2),
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundImage: NetworkImage(
                  userData.imageUrl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Moved _logout function outside the build method
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    context.go('/welcomescreen');
  }

  Widget buildAccountInfoList(BuildContext context) {
    return Column(
      children: [
     
        buildAccountInfoTile(
          context,
          icon: Icons.logout,
          color: Colors.red,
          title: 'Logout',
          onTap: () => _logout(context), // Use the _logout function
        ),
      ],
    );
  }

  Widget buildAccountInfoTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
