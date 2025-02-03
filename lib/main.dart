import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agronomist_partner/backend/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure plugin services are initialized
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
