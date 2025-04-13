import 'dart:convert';
import 'package:agronomist_partner/pages/bottomappbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String temperature = 'Loading...';
  String weatherCondition = '';
  String fromLocation = "Bangalore";
  String toLocation = "Salem";
  bool isToday = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _onImageTap() {}

  void swapLocations() {
    setState(() {
      final temp = fromLocation;
      fromLocation = toLocation;
      toLocation = temp;
    });
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

    // Function to change the date when tapped
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isToday = selectedDate.isAtSameMomentAs(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {

        // Format the selected date
    String formattedDate = DateFormat('dd MMM').format(selectedDate);
    String formattedDay = DateFormat('EEE').format(selectedDate);
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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // FROM section
                  GestureDetector(
                    onTap: () {
                      context.push('/searchpage');
                    },
                    child: Container(
                      height: 47,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/from.png', width: 24),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "FROM:",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                fromLocation,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // SWAP icon
                  GestureDetector(
                    onTap: swapLocations,
                    child: Image.asset('assets/images/swap.png', width: 20),
                  ),

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
                        Image.asset('assets/images/to.png',
                            width: 24, height: 40),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "TO:",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              toLocation,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
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
        // Calendar Icon with onTap functionality
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Image.asset(
            'assets/images/calender.png',
            width: 24,
          ),
        ),
        const SizedBox(width: 8),

        // "DATE" label
        GestureDetector(
          onTap: () => _selectDate(context),
      child:  Text(
          "DATE",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        )),
        const SizedBox(width: 8),

        // Displaying the selected date dynamically
        Text(
          formattedDate + ',',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(formattedDay),

        const Spacer(),

        // "Today" button with dynamic decoration and color
        GestureDetector(
          onTap: () {
            setState(() {
              isToday = true;
              selectedDate = DateTime.now(); // Set to today's date
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isToday ? Color(0xFF1B4EA0) : Colors.transparent,
              ),
              color: isToday ? Colors.white : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              "Today",
              style: TextStyle(
                color: isToday ? Color(0xFF1B4EA0) : Colors.black,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // "Tomorrow" button with dynamic decoration and color
        GestureDetector(
          onTap: () {
            setState(() {
              isToday = false;
              selectedDate = DateTime.now().add(Duration(days: 1)); // Set to tomorrow's date
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: !isToday ? Color(0xFF1B4EA0) : Colors.transparent,
              ),
              color: !isToday ? Colors.white : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              "Tomorrow",
              style: TextStyle(
                color: !isToday ? Color(0xFF1B4EA0) : Colors.black,
              ),
            ),
          ),
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
                          colors: [
                            Color(0xFF1B4EA0),
                            Color(0xFF1B4EA0),
                          ],
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
