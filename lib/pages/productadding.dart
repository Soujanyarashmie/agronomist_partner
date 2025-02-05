import 'package:agronomist_partner/backend/go_router.dart';
import 'package:agronomist_partner/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductUploadPage extends StatefulWidget {
final UserData userData = UserData();
ProductUploadPage({super.key,});

  @override
  _ProductUploadPageState createState() => _ProductUploadPageState();
}

class _ProductUploadPageState extends State<ProductUploadPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final UserData userData = UserData();
 Future<void> uploadProduct() async {
  if (nameController.text.isNotEmpty &&
      descriptionController.text.isNotEmpty &&
      priceController.text.isNotEmpty && userData.email != null) {
    try {
      double price = double.tryParse(priceController.text) ?? 0;
      if (price <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid price')));
        return;
      }
      String sanitizedEmail = userData.email.replaceAll('.', ','); // Sanitizing email for Firestore compatibility
      await FirebaseFirestore.instance
          .collection('user_products') // General collection for all user products
          .doc(sanitizedEmail) // Using sanitized email as document ID
          .collection('products') // Sub-collection for specific user's products
          .add({
            'name': nameController.text,
            'description': descriptionController.text,
            'price': price,
            'timestamp': FieldValue.serverTimestamp(),
            'email': userData.email, // Storing original email in the product details
          });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product uploaded successfully!')));
      nameController.clear();
      descriptionController.clear();
      priceController.clear();
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading product: $e')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
  }
}




  // Future<void> logout() async {
  //   await FirebaseAuth.instance.signOut();
  //   context.go('/loginpage');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
    appBar: AppBar(
      backgroundColor: Colors.green[100],
  title: Text('Upload Product'),
  actions: [
    InkWell(
      onTap: () {

       context.push('/profilepage');
      },
      child: userData.imageUrl.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(userData.imageUrl),
              radius: 25, // Radius of 15 will create a diameter of 30
            )
          : CircleAvatar(
              child: Text("No"),
              radius: 25,
            ),
    ),
    SizedBox(width: 20), 
  ],
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Product Description'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Product Price'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadProduct,
              child: Text('Upload Product'),
            ),
            SizedBox(height: 20),
           
          ],
        ),
      ),
    );
  }
}