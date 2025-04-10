import 'package:agronomist_partner/backend/go_router.dart';
import 'package:agronomist_partner/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

        final user = snapshot.data;
        final userData = UserData();

        if (user != null && !userData.isLoggedIn) {
          // Update UserData if Firebase user exists but our state isn't updated
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await userData.update(
              user.email ?? '',
              user.photoURL ?? '',
              user.displayName ?? '',
              true,
            );
          });
        }

        if (user == null && userData.isLoggedIn) {
          // User logged out elsewhere
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await userData.logout();
          });
        }

        if (user == null) {
          // If not logged in, redirect to login (handled by router redirect)
          return child;
        }

        // User is authenticated, show the protected content
        return child;
      },
    );
  }
}