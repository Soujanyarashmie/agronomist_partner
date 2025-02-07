import 'package:agronomist_partner/backend/go_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: Text(
          'My Address',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.green[100],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text(
          'No addresses added yet!',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80, // Adjust the height for padding around the container
        alignment: Alignment.center,
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
           context.push('/addaddress');
          },
          child: Container(
            width: 300,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.green[400],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              'Add New Address',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
