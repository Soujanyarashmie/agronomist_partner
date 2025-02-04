import 'package:agronomist_partner/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String gender = 'Prefer not to say';
  final UserData userData = UserData();
  


 Future<void> uploadProfile() async {
  if (nameController.text.isNotEmpty && ageController.text.isNotEmpty) {
    try {
      // Ensure the email identifier is sanitized or correctly formatted
      String emailDocument = userData.email.replaceAll('.', ','); // Example of handling email format

      // Adding to a subcollection 'personalinfo' under the specific user's email
      await FirebaseFirestore.instance
          .collection(emailDocument) // Use the sanitized/formatted email as collection name
          .doc('personalinfo') // Using 'personalinfo' document under the user's collection
          .set({ // Using set to create or overwrite the document data
            'name': nameController.text,
            'age': ageController.text,
          });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile uploaded successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields.')));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text("Gender:"),
            ListTile(
              title: const Text('Man'),
              leading: Radio<String>(
                value: 'Man',
                groupValue: gender,
                onChanged: (String? value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Woman'),
              leading: Radio<String>(
                value: 'Woman',
                groupValue: gender,
                onChanged: (String? value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Prefer not to say'),
              leading: Radio<String>(
                value: 'Prefer not to say',
                groupValue: gender,
                onChanged: (String? value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadProfile,
              child: Text('Upload Profile'),)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
