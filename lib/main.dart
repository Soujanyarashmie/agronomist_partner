import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:agronomist_partner/pages/login.dart';
import 'package:agronomist_partner/provider/location_provider.dart';
import 'package:agronomist_partner/provider/map_seletion.dart';
import 'package:agronomist_partner/backend/go_router.dart';
import 'package:sizer/sizer.dart';

// Function to handle background notifications
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔄 Background Message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Optional: Initialize local storage/user data
  await UserData().init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initFCM();
    _initLocalNotification(); // 👈 Add this line
    _listenToMessages();
  }

  void _initLocalNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      // iOS settings can be added here if needed
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

 

  void _initFCM() async {
    // Request permissions (important for iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('📲 Notification permission: ${settings.authorizationStatus}');

    // Get current FCM token
    String? token = await _messaging.getToken();
    print('✅ Initial FCM Token: $token');

    // Send the token to backend
    if (token != null) {
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

    // 🔄 Listen for FCM token refresh and send it to the backend
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print("🔄 New FCM token: $newToken");

      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      if (idToken != null) {
        final response = await http.post(
          Uri.parse(
              'https://cloths-api-backend.onrender.com/api/v1/user/update-fcm'),
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'fcmToken': newToken}),
        );

        if (response.statusCode == 200) {
          print("✅ Updated FCM token on backend.");
        } else {
          print("❌ Failed to update FCM token: ${response.statusCode}");
          print("❌ Response: ${response.body}");
        }
      }
    });
  }

  void _listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Foreground Message: ${message.notification?.title}');

      if (message.notification != null) {
        final title = message.notification?.title ?? '';
        final body = message.notification?.body ?? '';

        // ✅ Show local notification
        _flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel', // must match channel id
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );

        // Optional: Also show in a dialog
        _showDialog(title, body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('➡️ App opened via notification: ${message.data}');
      // Navigate if needed
    });
  }

  void _showDialog(String title, String body) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapSelectionProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: Sizer(
        // Wrap MaterialApp with Sizer
        builder: (context, orientation, deviceType) {
          return MaterialApp.router(
            routerConfig: router,
            title: 'Agronomist Partner',
            theme: ThemeData(primarySwatch: Colors.blue),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
