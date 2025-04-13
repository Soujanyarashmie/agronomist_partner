import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  final List<String> recentSearches = [
    "Bangalore - Salem",
    "Salem - Bangalore",
    "Salem"
  ];

  final List<Map<String, String>> popularCities = [
    {"name": "Bangalore", "icon": "assets/icons/bangalore.png"},
    {"name": "Chennai", "icon": "assets/icons/chennai.png"},
    {"name": "Hyderabad", "icon": "assets/icons/hyderabad.png"},
    {"name": "Coimbatore", "icon": "assets/icons/coimbatore.png"},
    {"name": "Mumbai", "icon": "assets/icons/mumbai.png"},
    {"name": "Pune", "icon": "assets/icons/pune.png"},
    {"name": "Delhi", "icon": "assets/icons/delhi.png"},
    {"name": "Goa", "icon": "assets/icons/goa.png"},
    {"name": "Jaipur", "icon": "assets/icons/jaipur.png"},
    {"name": "Madurai", "icon": "assets/icons/madurai.png"},
    {"name": "Nagpur", "icon": "assets/icons/nagpur.png"},
    {"name": "Indore", "icon": "assets/icons/indore.png"},
  ];

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInputField(Icons.arrow_back_ios_new, "From", fromController),
            const SizedBox(height: 10),
            _buildInputField(Icons.more_horiz, "To", toController),
            const SizedBox(height: 20),
            _buildSectionTitle("Recently searched"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((text) => _buildChip(text)).toList(),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Popular cities"),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.75,
              children: popularCities.map((city) {
                return Column(
                  children: [
                    Image.asset(city['icon']!, width: 36, height: 36),
                    const SizedBox(height: 6),
                    Text(city['name']!, style: const TextStyle(fontSize: 13)),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hint, TextEditingController controller) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_city, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
