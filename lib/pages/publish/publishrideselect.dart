import 'dart:convert';

import 'package:agronomist_partner/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PublishRideSelectPage extends StatelessWidget {
  const PublishRideSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    final bool bothLocationsSelected =
        locationProvider.publishFromLocation != "Select Location" &&
            locationProvider.publishToLocation != "Select Location";

    Future<void> getApproxPrice() async {
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);

      double fromLat = locationProvider.publishFromLat;
      double fromLng = locationProvider.publishFromLng;
      double toLat = locationProvider.publishToLat;
      double toLng = locationProvider.publishToLng;

      final url =
          'https://cloths-api-backend.onrender.com/api/v1/calculate-price';

      final body = {
        'fromLat': fromLat,
        'fromLon': fromLng,
        'toLat': toLat,
        'toLon': toLng,
      };

      debugPrint('\n📤 Sending price calculation request...');
      debugPrint('Request URL: $url');
      debugPrint('Request Body: $body');

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        debugPrint('📩 Response Status Code: ${response.statusCode}');
        debugPrint('📩 Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          debugPrint('✅ Parsed API Response: $data');

          if (data['price'] != null) {
            debugPrint('💰 Price calculated: ${data['price']}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Price calculated successfully!')),
            );
          } else {
            debugPrint('⚠️ Price field missing in response.');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Price not found in response')),
            );
          }
        } else {
          debugPrint('❌ API returned error: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to calculate price: ${response.body}'),
            ),
          );
        }
      } catch (e) {
        debugPrint('🛑 Exception during API call: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 0), // You can adjust the value
                  child: GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/publishstack.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
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

          // Positioned card below the image
          Positioned(
            top: MediaQuery.of(context).size.height * 0.38, // 10% below image
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Where to?',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Container(
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
                    children: [
                      // FROM
                      GestureDetector(
                        onTap: () async {
                          final result = await context.push('/mapPicker',
                              extra: {'isFrompublishLocation': true});
                          if (result != null &&
                              result is Map<String, dynamic>) {
                            Provider.of<LocationProvider>(context,
                                    listen: false)
                                .updatePublishFromLocation(
                              result['locality'] ?? "Select Location",
                              result['latitude'] ?? 0.0,
                              result['longitude'] ?? 0.0,
                            );
                          }
                        },
                        child: Consumer<LocationProvider>(
                          builder: (context, locationProvider, child) {
                            return Container(
                              height: 47,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Image.asset('assets/images/from.png',
                                      width: 24),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("FROM:",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      const SizedBox(height: 2),
                                      Text(
                                        locationProvider.publishFromLocation,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // TO
                      GestureDetector(
                        onTap: () async {
                          final result = await context.push('/mapPicker',
                              extra: {'isToPublishLocation': true});
                          if (result != null &&
                              result is Map<String, dynamic>) {
                            Provider.of<LocationProvider>(context,
                                    listen: false)
                                .updatePublishToLocation(
                              result['locality'] ?? "Select Location",
                              result['latitude'] ?? 0.0,
                              result['longitude'] ?? 0.0,
                            );
                          }
                        },
                        child: Consumer<LocationProvider>(
                          builder: (context, locationProvider, child) {
                            return Container(
                              height: 47,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Image.asset('assets/images/to.png',
                                      width: 24),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("TO:",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      const SizedBox(height: 2),
                                      Text(
                                        locationProvider.publishToLocation,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (bothLocationsSelected)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Adjust padding as needed
                child: ArrowButton(
                  onTap: () async {
                    await getApproxPrice(); // Call the function
                    context
                        .push('/publishride'); // Navigate after getting price
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ArrowButton extends StatelessWidget {
  final VoidCallback onTap;

  const ArrowButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xFF1B4EA0),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
