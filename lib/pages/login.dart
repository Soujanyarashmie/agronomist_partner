import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// 🔧 Reusable function to get ID token
Future<String?> getFirebaseIdToken() async {
  final user = FirebaseAuth.instance.currentUser;
  return await user?.getIdToken();
}

// 🔧 Reusable function to add product with token
Future<void> addProduct(Map<String, dynamic> productData) async {
  final idToken = await getFirebaseIdToken();

  if (idToken == null) {
    print("❌ No ID token found. User might not be logged in.");
    return;
  }

  final response = await http.post(
    Uri.parse("https://cloths-api-backend.onrender.com/api/v1/products"),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(productData),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("✅ Product added successfully!");
  } else {
    print("❌ Failed to add product: ${response.statusCode}");
    print("❌ Response: ${response.body}");
  }
}

class UserData {
  static final UserData _instance = UserData._internal();
  factory UserData() => _instance;
  UserData._internal();

  String email = '';
  String imageUrl = '';
  String name = '';
  bool isLoggedIn = false;

  // 👇 Add these new fields
  String phone = '';
  String dob = '';
  List<String> about = [];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    imageUrl = prefs.getString('imageUrl') ?? '';
    name = prefs.getString('name') ?? '';
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> update(
      String email, String imageUrl, String name, bool isLoggedIn) async {
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

  Future<String> getFirebaseToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken() ?? '';
  }

  Future<String> getFirebaseUid() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    final prefs = await SharedPreferences.getInstance();
   // await prefs.clear();
    email = '';
    imageUrl = '';
    name = '';
    isLoggedIn = false;
    phone = '';
    dob = '';
    about = [];
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

  Future<void> sendFCMTokenToBackend(String token) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    if (idToken != null) {
      final response = await http.post(
        Uri.parse(
            'https://cloths-api-backend.onrender.com/api/v1/user/update-fcm'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'fcmToken': token}),
      );

      if (response.statusCode == 200) {
        print("✅ FCM token sent to backend successfully.");
      } else {
        print("❌ Failed to send FCM token: ${response.statusCode}");
        print("❌ Response: ${response.body}");
      }
    }
  }

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

          final token = await user.getIdToken(true);
          debugPrint("🔥 Firebase ID Token: $token", wrapWidth: 1024);

          // ✅ Save user in backend DB (MongoDB)
          final saveUserResponse = await http.post(
            Uri.parse(
                'https://cloths-api-backend.onrender.com/api/v1/user/save'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'name': user.displayName ?? '',
              'photoURL': user.photoURL ?? '',
            }),
          );

          if (saveUserResponse.statusCode == 200) {
            print("✅ User saved or already exists in MongoDB.");
          } else {
            print("❌ Failed to save user: ${saveUserResponse.statusCode}");
            print("❌ Response: ${saveUserResponse.body}");
          }

          // ✅ Send token to backend - TEST / GET
          final response = await http.get(
            Uri.parse(
                'https://cloths-api-backend.onrender.com/api/v1/test-auth'),
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            print('✅ Authenticated with backend: ${response.body}');
          } else {
            print('❌ Backend error: ${response.statusCode}');
            print('❌ Response body: ${response.body}');
          }

          // 👉 Navigate after backend tasks
          if (mounted) {
            context.go('/mainpage');
          }
          // 🔁 Send FCM token after login
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await sendFCMTokenToBackend(fcmToken);
          }
        }
      }
    } catch (e) {
      print("❌ Error signing in with Google: $e");
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 0), // Move 8 pixels more to the left
                  child: IconButton(
                    icon: Icon(Icons.close, size: 25, color: Colors.red[500]),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
              ),

              SizedBox(height: 20),
              Text(
                'How do you want to log in?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 30),

              // Continue with Email
              if (_isSigningIn)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: signInWithGoogle,
                    icon: Image.asset(
                      'assets/images/google.png',
                      width: 25,
                      height: 25,
                    ),
                    label: Text(
                      'Continue with email',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 16),

              // Continue with Facebook
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Facebook login
                  },
                  icon: FaIcon(FontAwesomeIcons.facebookF, color: Colors.white),
                  label: Text(
                    'Continue with Facebook',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4267B2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Continue with Apple
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Apple login
                  },
                  icon: FaIcon(FontAwesomeIcons.apple, color: Colors.white),
                  label: Text(
                    'Continue with Apple',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              Spacer(),

              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to Sign Up
                      },
                      child: Text(
                        'Terms & conditions',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
