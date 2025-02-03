import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Upload',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductUploadPage(),
    );
  }
}

class ProductUploadPage extends StatefulWidget {
  @override
  _ProductUploadPageState createState() => _ProductUploadPageState();
}

class _ProductUploadPageState extends State<ProductUploadPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Upload product data to Firestore
  Future<void> uploadProduct() async {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty) {
      try {
        // Store data in Firestore
        await FirebaseFirestore.instance.collection('products').add({
          'name': nameController.text,
          'description': descriptionController.text,
          'price': double.parse(priceController.text),
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product uploaded successfully!')));

        // Clear the form
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
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
      appBar: AppBar(title: Text('Upload Product')),
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
          ],
        ),
      ),
    );
  }
}
