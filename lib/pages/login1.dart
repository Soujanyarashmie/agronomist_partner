// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';


// class LoginPage1 extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage1> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: IconButton(
//                   icon: Icon(Icons.close, color: Colors.blue),
//                   onPressed: () {
//                     // Close action
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'How do you want to log in?',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 30),

//               // Continue with Email
//               if (_isSigningIn)
//                 const CircularProgressIndicator()
//                 else
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton.icon(
//                   onPressed :signInWithGoogle,
//                   icon: Icon(Icons.mail_outline, color: Colors.white),
//                   label: Text(
//                     'Continue with email',
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.lightBlueAccent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 16),

//               // Continue with Facebook
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     // Facebook login
//                   },
//                   icon: FaIcon(FontAwesomeIcons.facebookF, color: Colors.white),
//                   label: Text(
//                     'Continue with Facebook',
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF4267B2),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 16),

//               // Continue with Apple
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     // Apple login
//                   },
//                   icon: FaIcon(FontAwesomeIcons.apple, color: Colors.white),
//                   label: Text(
//                     'Continue with Apple',
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),

//               Spacer(),

//               Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       'Not a member yet?',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     GestureDetector(
//                       onTap: () {
//                         // Navigate to Sign Up
//                       },
//                       child: Text(
//                         'Sign up',
//                         style: TextStyle(
//                           color: Colors.lightBlue,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
