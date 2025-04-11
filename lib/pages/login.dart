import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

          // ✅ POST hardcoded product data
          final productResponse = await http.post(
            Uri.parse(
                'https://cloths-api-backend.onrender.com/api/v1/products'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: const JsonEncoder().convert({
              "name": "Cool T-Shirt",
              "price": 29.99,
              "description": "A super cool t-shirt with minimal design",
              "category": "T-Shirts",
              "stock": 20,
              "seller": "Flutter App",
              "ratings": 4.5,
              "ratingcount": 12,
              "images": [
                {
                  "url": "https://example.com/image1.jpg",
                }
              ],
              "isfavourite": false,
            }),
          );

          if (productResponse.statusCode == 201 ||
              productResponse.statusCode == 200) {
            print("✅ Product added successfully: ${productResponse.body}");
          } else {
            print("❌ Failed to add product: ${productResponse.statusCode}");
            print("❌ Response: ${productResponse.body}");
          }

          // 👉 Navigate after backend tasks
          if (mounted) {
            context.go('/mainpage');
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
