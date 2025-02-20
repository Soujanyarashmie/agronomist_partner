import 'package:flutter/material.dart';


class AddNewAddressPage extends StatelessWidget {
  const AddNewAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200], // Light green background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Add New Address ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
      ),
      body: const AddressForm(),
    );
  }
}


class AddressForm extends StatelessWidget {
  const AddressForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "First name"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Last name"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: "Address"),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration:
                const InputDecoration(labelText: "Apartment, suite, etc."),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: "City"),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "State/province"),
            items: ["State 1", "State 2", "State 3"]
                .map((state) =>
                    DropdownMenuItem(value: state, child: Text(state)))
                .toList(),
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Country"),
            items: ["Country 1", "Country 2", "Country 3"]
                .map((country) =>
                    DropdownMenuItem(value: country, child: Text(country)))
                .toList(),
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: "ZIP/postal code"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
