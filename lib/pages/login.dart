import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// User Data Singleton
class UserData {
  static final UserData _instance = UserData._internal();
  factory UserData() => _instance;
  UserData._internal();

  String email = '';
  String imageUrl = '';
  String name = '';
  bool isLoggedIn = false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    imageUrl = prefs.getString('imageUrl') ?? '';
    name = prefs.getString('name') ?? '';
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> update(String email, String imageUrl, String name, bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('imageUrl', imageUrl);
    await prefs.setString('name', name);
    await prefs.setBool('isLoggedIn', isLoggedIn);
    
    this.email = email;
    this.imageUrl = imageUrl;
    this.name = name;
    this.isLoggedIn = isLoggedIn;
    print('User Data Updated: email=$email, isLoggedIn=$isLoggedIn');
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    email = '';
    imageUrl = '';
    name = '';
    isLoggedIn = false;
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
  setState(() => _isSigningIn = true);
  
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
        final user = userCredential.user!;
        await UserData().update(
          user.email ?? '',
          user.photoURL ?? '',
          user.displayName ?? '',
          true,
        );
        
        if (mounted) {
          context.go('/location');
        }
      }
    }
  } catch (e) {
    print("Error signing in with Google: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: ${e.toString()}')),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isSigningIn = false);
    }
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
