// import 'package:agronomist_partner/pages/login.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:agronomist_partner/components/bottomappbar.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:go_router/go_router.dart';

// class Listedproducts extends StatefulWidget {
//   @override
//   _ProductsPageState createState() => _ProductsPageState();
// }

// class _ProductsPageState extends State<Listedproducts> {
//   final UserData userData = UserData();

//   // Stream builder method to listen to product updates
//   Stream<List<DocumentSnapshot>> streamProducts() {
//     return FirebaseFirestore.instance
//         .collection('users/${userData.email}/products')
//         .snapshots()
//         .map((snapshot) {
//           print("Number of products fetched: ${snapshot.docs.length}");
//           return snapshot.docs;
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products List'),
//         backgroundColor: Colors.green[100],
//       ),
//       body: StreamBuilder<List<DocumentSnapshot>>(
//         stream: streamProducts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 var product = snapshot.data![index].data() as Map<String, dynamic>;
//                 return ListTile(
//                   leading: Icon(Icons.store),
//                   title: Text(product['name'] ?? 'No name provided'),
//                   subtitle: Text(product['description'] ?? 'No description provided'),
//                   trailing: Text('\$${product['price'] ?? 'Price not available'}'),
//                 );
//               },
//             );
//           } else {
//             return Container(
//               color: Colors.yellow[50],
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset('assets/images/bag.png', width: 200, height: 200),
//                     const Text(
//                       'Your Product is Empty',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//       bottomNavigationBar: const LowerBottomAppBar(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           context.push('/sellproduct');
//         },
//         backgroundColor: Colors.teal,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }

import 'package:agronomist_partner/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final UserData userData = UserData();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Stream<List<Product>> readProducts() {
  final user = _auth.currentUser;
  if (user == null || user.email == null) {
    throw FirebaseAuthException(
      code: 'ERROR_NO_USER',
      message: 'No user logged in or email missing',
    );
  }
  
  String sanitizedEmail = user.email!.replaceAll('.', ',');
  print('Querying Firestore with sanitized email: $sanitizedEmail'); // Debug line to check the email format
  return _firestore
      .collection('user_products')
      .doc(sanitizedEmail)
      .collection('products')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList());
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        backgroundColor: Colors.green[100],
      ),
      body: StreamBuilder<List<Product>>(
        stream: readProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index].name),
                  subtitle: Text(products[index].description),
                  trailing: Text('\$${products[index].price.toStringAsFixed(2)}'),
                );
              },
            );
          } else {
            return Center(child: Text('No products found'));
          }
        },
      ),
    );
  }
}

class Product {
  final String name;
  final String description;
  final double price;
  final DocumentReference reference;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.reference,
  });

  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Product(
      name: data['name'],
      description: data['description'],
      price: data['price'],
      reference: snapshot.reference,
    );
  }
}
