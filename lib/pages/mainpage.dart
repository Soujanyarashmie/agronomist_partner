import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String temperature = 'Loading...';
  String weatherCondition = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _onImageTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image tapped!')),
    );
  }

  Future<void> _fetchWeather() async {
    try {
      final lat = 12.9531904;
      final lon = 77.6536064;
      const apiKey = 'bc3a245ed7c56bc1f7e7131abb0cdca5';

      final url = Uri.parse(
        'http://api.weatherstack.com/current?access_key=$apiKey&query=$lat,$lon',
      );

      final response = await http.get(url);
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = '${data['current']['temperature']}°C';
          weatherCondition = data['current']['weather_descriptions'][0];
        });
      } else {
        setState(() {
          temperature = 'Error';
          weatherCondition = 'Unavailable';
        });
      }
    } catch (e) {
      print('Exception: $e');
      setState(() {
        temperature = 'Error';
        weatherCondition = 'Unavailable';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: _onImageTap,
                  child: Image.asset(
                    'assets/images/scooter_signin_image.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // Positioned floating search box
          Positioned(
            top: MediaQuery.of(context).size.height * 0.42,
            left: 20,
            right: 20,
            child: Container(
              height: 270,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // FROM section
             // FROM section
Container(
  height: 47,
  padding: const EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    children: [
      Image.asset('assets/images/google.png', width: 24),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "FROM:",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Bangalore",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ],
  ),
),

                
 Image.asset('assets/images/swap.png', width: 20),
           // TO section
Container(
  height: 47,
  padding: const EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    children: [
      Image.asset('assets/images/google.png', width: 24),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "To",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            "Salem",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ],
  ),
),

                  const SizedBox(height: 16),

                  // DATE + Buttons
                  Row(
                    children: [
                      Image.asset('assets/images/calender.png',
                          width: 24), // Calendar icon
                      const SizedBox(width: 8),
                      const Text("DATE",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      const SizedBox(width: 8),
                      const Text("11 Apr,",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text(" Fri"),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: const Text("Today",
                            style: TextStyle(color: Colors.blue)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: const Text("Tomorrow"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3A8DFF), Color(0xFF0D61F2)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "SEARCH BIKES",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Weather Overlay
          Positioned(
            top: 40,
            left: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/cloud.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      temperature,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weatherCondition,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
