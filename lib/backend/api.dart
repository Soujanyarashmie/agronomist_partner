// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;

// Future<void> sendToBackend() async {
//   try {
//     // Get the current Firebase user
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       print('❌ No user is logged in');
//       return; // Exit early if no user is logged in
//     }

//     print('✅ User is logged in: ${user.email}');

//     // Get the Firebase ID token
//     String? token;
//     try {
//       print('🔄 Attempting to get Firebase ID token...');
//       token = await user.getIdToken();
//       if (token == null) {
//         print('❌ Failed to get Firebase ID token');
//         return; // Exit early if token retrieval fails
//       }
//       print('✅ Successfully retrieved Firebase ID token');
//     } catch (e) {
//       print('❌ Error getting Firebase token: $e');
//       return; // Exit early if token retrieval fails
//     }

//     // Make the API request with the Authorization header
//     print('🔄 Sending request to backend...');
//     final response = await http.get(
//       Uri.parse('https://cloths-api-backend.onrender.com/api/protected'),
//       headers: {
//         'Authorization': 'Bearer $token', // Attach the Firebase token in the Authorization header
//       },
//     );

//     // Check the response status and handle accordingly
//     if (response.statusCode == 200) {
//       print('✅ Backend Response: ${response.body}');
//     } else {
//       print('❌ Backend Error: ${response.statusCode}');
//       if (response.statusCode == 401) {
//         print('⚠️ Unauthorized: Invalid token or expired session');
//       } else if (response.statusCode == 403) {
//         print('⚠️ Forbidden: You do not have permission to access this resource');
//       } else {
//         print('⚠️ Other error: ${response.statusCode}');
//       }
//     }
//   } catch (e) {
//     print('❌ Error sending request to backend: $e');
//   }
// }
