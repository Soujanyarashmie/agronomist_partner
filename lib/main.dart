import 'package:agronomist_partner/pages/login.dart';

import 'package:agronomist_partner/provider/location_provider.dart';
import 'package:agronomist_partner/provider/map_seletion.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agronomist_partner/backend/go_router.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserData().init(); // Initialize user data
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapSelectionProvider()),
        // Add more providers here as needed
        ChangeNotifierProvider(create: (_) => LocationProvider()),
       
      ],

      child: MaterialApp.router(
        routerConfig: router,
        title: 'Agronomist Partner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
