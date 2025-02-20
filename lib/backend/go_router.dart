import 'package:agronomist_partner/pages/address.dart';
import 'package:agronomist_partner/pages/editprofile.dart';
import 'package:agronomist_partner/pages/listedproducts.dart';
import 'package:agronomist_partner/pages/myaddress.dart';
import 'package:agronomist_partner/pages/productadding.dart';
import 'package:agronomist_partner/pages/sellproduct.dart';
import 'package:agronomist_partner/pages/location.dart';
import 'package:agronomist_partner/pages/login.dart';
import 'package:agronomist_partner/pages/mainpage.dart';
import 'package:agronomist_partner/pages/profilemenu.dart';
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
      return Sellproduct();
    },
  ),
  GoRoute(
    path: '/loginpage',
    builder: (context, state) => LoginPage(),
  ),
  GoRoute(
    path: '/location',
    builder: (context, state) => Location(),
  ),
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
    path: '/listedproduct',
    builder: (context, state) => ProductListPage(),
  ),
  GoRoute(
    path: '/sellproduct',
    builder: (context, state) => Sellproduct(),
  ),
  GoRoute(
    path: '/productupload',
    builder: (context, state) => ProductUploadPage(),
  ),
  GoRoute(
    path: '/addaddress',
    builder: (context, state) => MyAddressPage(),
  ),
  GoRoute(
    path: '/myaddress1',
    builder: (context, state) => const AddressForm(),
  ),
  GoRoute(
    path: '/editprofile',
    builder: (context, state) => EditProfileScreen(),
  ),
  GoRoute(
    path: '/myaddress',
    builder: (context, state) => MyAddressPage(),
  ),
   GoRoute(
      path: '/',
      builder: (context, state) => MyAddressPage(),
    ),
    GoRoute(
      path: '/addnewaddress',
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Add New Address'),
        ), 
         body: AddressForm(),
      ),
    ),
  ],
); 











