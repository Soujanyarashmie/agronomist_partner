import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';

// User Data Singleton
class UserData {
  static final UserData _instance = UserData._internal();
  factory UserData() => _instance;

  UserData._internal();

  String email = '';
  String imageUrl = '';
  String name ='';

  void update(String email, String imageUrl, String name) {
    this.email = email;
    this.imageUrl = imageUrl;
    this.name = name;
    print('User Data Updated: email=$email, imageUrl=$imageUrl');
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSigningIn = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          print("Signed in as ${userCredential.user!.displayName}");

          // Retrieve email and profile image URL from the user credential
          final String email = userCredential.user!.email ?? "No email found";
          final String imageUrl =
              userCredential.user!.photoURL ?? "No image available";
          // Update UserData singleton with the new user information
          final String name = userCredential.user!.displayName ?? "No name found";
          UserData().update(email, imageUrl, name);

          // Navigate to the main page after successful login
          context.go('/location');
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (_isSigningIn)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: signInWithGoogle,
                    // onPressed: () {
                    //   context.push('/mainpage');
                    //},
                    child: const Text("Sign in with Google"),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
