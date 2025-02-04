import 'package:agronomist_partner/pages/homepage.dart';
import 'package:agronomist_partner/pages/login.dart';
import 'package:agronomist_partner/pages/profilepage.dart';
import 'package:agronomist_partner/pages/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(initialLocation: '/splashscreen', routes: [
  GoRoute(
    path: '/splashscreen',
    builder: (context, state) => SplashScreenWidget(),
  ),
  GoRoute(
  path: '/homepage',
  builder: (BuildContext context, GoRouterState state) {
  
    return ProductUploadPage(); 
  },
),

  GoRoute(
    path: '/loginpage',
    builder: (context, state) => LoginPage(),
  ),

   GoRoute(
    path: '/profilepage',
    builder: (context, state) =>ProfilePage(),
  ),
]);
