import 'package:agronomist_partner/pages/editprofile.dart';

import 'package:agronomist_partner/pages/login.dart';
import 'package:agronomist_partner/pages/mainpage.dart';
import 'package:agronomist_partner/pages/profilemenu.dart';
import 'package:agronomist_partner/pages/profilepage.dart';


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
    // Check auth state
    final isLoggedIn = _auth.currentUser != null;
    final isLoggingIn = state.uri.toString() == '/loginpage';

    // If not logged in and not going to login page, redirect to login
    if (!isLoggedIn && !isLoggingIn) {
      return '/welcomescreen';
    }

    // If logged in and trying to go to login page, redirect to home
    if (isLoggedIn && isLoggingIn) {
      return '/mainpage';
    }

    // No redirect needed
    return null;
  },
  routes: [
    // Public routes
    GoRoute(
      path: '/splashscreen',
      builder: (context, state) => SplashScreenWidget(),
    ),
    GoRoute(
      path: '/loginpage',
      builder: (context, state) => LoginPage(),
    ),

    // Protected routes (require authentication)
    ShellRoute(
      builder: (context, state, child) {
        return AuthWrapper(child: child);
      },
      routes: [
        GoRoute(
          path: '/profilepage',
          builder: (context, state) => ProfilePage(),
        ),
        GoRoute(
          path: '/mainpage',
          builder: (context, state) => MainPage(),
        ),
        GoRoute(
          path: '/profilemenu',
          builder: (context, state) => ProfileMenu(),
        ),
        GoRoute(
          path: '/editprofile',
          builder: (context, state) => EditProfileScreen(),
        ),
        GoRoute(
          path: '/welcomescreen',
          builder: (context, state) => WelcomeScreen(),
        ),
      ],
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
