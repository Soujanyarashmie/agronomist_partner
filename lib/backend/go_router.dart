import 'package:agronomist_partner/gmaps.dart';
import 'package:agronomist_partner/pages/bottomappbar.dart';
import 'package:agronomist_partner/pages/editprofile.dart';

import 'package:agronomist_partner/pages/login.dart';

import 'package:agronomist_partner/pages/mainpage.dart';
import 'package:agronomist_partner/pages/profilemenu.dart';
import 'package:agronomist_partner/pages/profilepage.dart';
import 'package:agronomist_partner/pages/publish/publishride.dart';
import 'package:agronomist_partner/pages/publish/yourrides.dart';
import 'package:agronomist_partner/pages/searchpage.dart';

import 'package:agronomist_partner/pages/splash_screen/splashscreen.dart';
import 'package:agronomist_partner/pages/welcomescreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;

// Auth state stream
Stream<User?> get authStateChanges => _auth.authStateChanges();

final GoRouter router = GoRouter(
  initialLocation: '/splashscreen',
  redirect: (BuildContext context, GoRouterState state) {
    final isLoggedIn = _auth.currentUser != null;
    final isLoggingIn = state.uri.toString() == '/loginpage';

    if (!isLoggedIn && !isLoggingIn) {
      return '/welcomescreen';
    }

    if (isLoggedIn && isLoggingIn) {
      return '/mainpage';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splashscreen',
      builder: (context, state) => SplashScreenWidget(),
    ),
    GoRoute(
      path: '/loginpage',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/welcomescreen',
      builder: (context, state) => WelcomeScreen(),
    ),
GoRoute(
  path: '/searchpage',
  builder: (context, state) {
    // Extract the location data from the extra parameters as Map<String, Object>
    final locationData = state.extra as Map<String, Object>? ?? {};
    return SearchPage(locationData: locationData);
  },
),


        GoRoute(
      path: '/mapPicker',
      builder: (context, state) => GoogleMapLocationPicker(),
    ),

    /// 👇 ShellRoute with BottomNavigation
    ShellRoute(
      builder: (context, state, child) {
        return AuthWrapper(child: BottomAppBarNav(child: child));
      },
      routes: [
        GoRoute(
          path: '/mainpage',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/publish',
          builder: (context, state) => PublishRidePage(),
        ),
        GoRoute(
          path: '/rides',
          builder: (context, state) => YourRidespage(),
        ),
        GoRoute(
          path: '/inbox',
          builder: (context, state) => ProfileMenu()
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileMenu(),
        ),
       
      ],
    ),

    // Optional: outside bottom nav, but protected
    GoRoute(
      path: '/profilemenu',
      builder: (context, state) => ProfileMenu(),
    ),
    GoRoute(
      path: '/editprofile',
      builder: (context, state) => EditProfileScreen(),
    ),
  ],
);

// Auth wrapper widget
class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (snapshot.data == null) {
          // If not logged in, redirect to login (handled by router redirect)
          return child;
        }

        // User is authenticated, show the protected content
        return child;
      },
    );
  }
}
