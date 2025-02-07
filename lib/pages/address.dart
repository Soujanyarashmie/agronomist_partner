import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  // Controllers for TextFields
  final TextEditingController houseController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    houseController.dispose();
    apartmentController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: Text('Add Address'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.green[100],
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          GestureDetector(
            onTap: () {
              // Add your save functionality here
              print('House: ${houseController.text}');
              print('Apartment: ${apartmentController.text}');
              print('Address: ${addressController.text}');
              print('City: ${cityController.text}');
              print('State: ${stateController.text}');
              print('Postal Code: ${postalCodeController.text}');
              print('Country: ${countryController.text}');
            },
            child: Container(
              width: 80,
              height: 30,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 151, 189, 48),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero, // Remove padding to allow edge-to-edge container
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures children stretch to full width
          children: [
            SizedBox(height: 30),
            // Home/Flat/Block Number
            buildAddressField(
              label: 'Home/Flat/Block Number',
              hintText: 'Enter Home/Flat/Block Number',
              controller: houseController,
            ),
            SizedBox(height: 20),
            // Apartment/Road/Area
            buildAddressField(
              label: 'Apartment/Road/Area',
              hintText: 'Enter Apartment/Road/Area',
              controller: apartmentController,
            ),
            SizedBox(height: 20),
            // Location Button
            buildLocationField(label: 'Location'),
            SizedBox(height: 20),
            // Address
            buildAddressField(
              label: 'Address',
              hintText: 'Enter Address',
              controller: addressController,
            ),
            SizedBox(height: 20),
            // City
            buildAddressField(
              label: 'City',
              hintText: 'Enter City',
              controller: cityController,
            ),
            SizedBox(height: 20),
            // State
            buildAddressField(
              label: 'State',
              hintText: 'Enter State',
              controller: stateController,
            ),
            SizedBox(height: 20),
            // Postal Code
            buildAddressField(
              label: 'Postal Code',
              hintText: 'Enter Postal Code',
              controller: postalCodeController,
            ),
            SizedBox(height: 20),
            // Country
            buildAddressField(
              label: 'Country',
              hintText: 'Enter Country',
              controller: countryController,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildAddressField({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[300]!, Colors.white, Colors.grey[300]!],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 40,
              child: TextField(
                controller: controller,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLocationField({required String label}) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[300]!, Colors.white, Colors.grey[300]!],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              // Add your location selection functionality here
              print("Choose location tapped");
            },
            child: Container(
              width: 120,
              height: 30,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 151, 189, 48),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Text(
                "Choose Location",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
