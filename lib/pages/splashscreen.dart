import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Assuming this is the next screen after the splash

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start opacity animation
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to next page after some delay
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/LocationPage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 2),
          child: Image.asset(
              'assets/images/agrilogo1.png'), // Correct the asset path as needed
        ),
      ),
    );
  }
}
