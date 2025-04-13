import 'dart:convert';
import 'package:agronomist_partner/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserData userData = UserData();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> updateUserProfile() async {
  final token = await userData.getFirebaseToken();
  final uid = await userData.getFirebaseUid();

  // Gather the updated data from the controllers
  final phone = phoneController.text;
  final dob = dobController.text;
  final about = aboutController.text.split(', '); // Assuming about is a comma-separated list

  final updatedData = {
    'phone': phone,
    'dob': dob,
    'aboutUser': about,
  };

  try {
    final response = await http.post(
      Uri.parse('https://cloths-api-backend.onrender.com/api/v1/user/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      // Handle success
      print("✅ Profile updated successfully.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      // Optionally, you can reload the user data here
      fetchUserProfile();
    } else {
      // Handle failure
      print("❌ Failed to update profile: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile!')),
      );
    }
  } catch (e) {
    print("❌ Error updating profile: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating profile: $e')),
    );
  }
}


  Future<void> fetchUserProfile() async {
  final token = await userData.getFirebaseToken();
  final uid = await userData.getFirebaseUid(); 
  print("🔐 Token: $token");
  print("👤 UID: $uid");

  try {
    final response = await http.get(
      Uri.parse('https://cloths-api-backend.onrender.com/api/v1/user/$uid'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("📥 Status: ${response.statusCode}");
    print("📥 Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final userMap = jsonBody['user'];

      userData.phone = userMap['phone'] ?? '';
      userData.dob = userMap['dob'] ?? '';
      userData.about = List<String>.from(userMap['aboutUser'] ?? []);

      phoneController.text = userData.phone;
      dobController.text = userData.dob;
      aboutController.text = userData.about.join(', ');

      setState(() => isLoading = false);
    } else {
      print("❌ Failed to fetch user data: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Error fetching profile: $e");
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 70.0,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                        ),
                      ),
                      Positioned(
                        bottom: -60,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(userData.imageUrl),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Profile Picture",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        buildStaticField("Username", userData.name),
                        buildStaticField("Email ID", userData.email),
                        buildTextField("Phone Number", phoneController),
                        buildDateField(context, "Date of Birth", dobController),
                        buildTextField("About You", aboutController),
                        SizedBox(height: 20),
                       GestureDetector(
  onTap: () {
    updateUserProfile(); // Call the update function here
  },
  child: Container(
    width: 250,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.green[300],
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: Text(
      "Update",
      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
),

                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildStaticField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(value, style: TextStyle(fontSize: 16, color: Colors.black)),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: label == "About You" ? 3 : 1,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildDateField(BuildContext context, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              controller.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
            });
          }
        },
      ),
    );
  }
}
