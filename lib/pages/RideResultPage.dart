import 'package:agronomist_partner/backend/go_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RideResultPage extends StatelessWidget {
  final List rides;
  const RideResultPage({super.key, required this.rides});

  @override
Widget build(BuildContext context) {
  // Sort rides: available (seatsAvailable > 0) first, then full
  final sortedRides = [...rides]; // Copy original list to avoid modifying it
  sortedRides.sort((a, b) {
    final seatsA = a['seatsAvailable'] ?? 0;
    final seatsB = b['seatsAvailable'] ?? 0;
    return (seatsB > 0 ? 1 : 0) - (seatsA > 0 ? 1 : 0);
  });

  return Scaffold(
    backgroundColor: const Color(0xFFF5F5F5),
    appBar: AppBar(
      title: const Text('Ride Results'),
      centerTitle: true,
      backgroundColor: const Color(0xFF1B4EA0),
    ),
    body: Container(
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
        itemCount: sortedRides.length,
        itemBuilder: (context, index) {
          final ride = sortedRides[index];
            final int seatsAvailable = ride['seatsAvailable'] ?? 0;
            final bool isAvailable = seatsAvailable > 0;

            final TextStyle dimmedStyle = TextStyle(color: Colors.grey[500]);

            return GestureDetector(
              onTap: isAvailable
                  ? () => context.push('/booking', extra: ride)
                  : null,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${ride['from']['city']} → ${ride['to']['city']}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  isAvailable ? Colors.black : Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bharat Benz A/C Sleeper (2+1)',
                            style: TextStyle(
                              color: isAvailable
                                  ? Colors.grey[600]
                                  : Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                '${ride['startTime']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable
                                      ? Colors.black
                                      : Colors.grey[500],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '–  4h 0m  –',
                                style: TextStyle(
                                  color: isAvailable
                                      ? Colors.grey
                                      : Colors.grey[400],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${ride['endTime']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable
                                      ? Colors.black
                                      : Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Date: ${ride['date'].substring(0, 10)} ",
                            style: TextStyle(
                              color: isAvailable
                                  ? Colors.grey[600]
                                  : Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 12),

// Driver Profile Row (based on screenshot)
                          Row(
                            children: [
                              const Icon(Icons.bike_scooter,
                                  color: Colors.grey),
                              const SizedBox(width: 10),
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: ride['user'] != null &&
                                            ride['user']['photoURL'] != null
                                        ? NetworkImage(ride['user']['photoURL'])
                                        : null,
                                    child: ride['user'] == null ||
                                            ride['user']['photoURL'] == null
                                        ? Icon(Icons.person,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      padding: const EdgeInsets.all(2),
                                      child: const Icon(Icons.check,
                                          size: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ride['user']?['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      // Text(
                                      //   '${ride['driver']['rating'] ?? 4}',
                                      //   style: const TextStyle(
                                      //     fontSize: 14,
                                      //     color: Colors.grey,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.people_outline,
                                  color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),

                    // Right Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                isAvailable ? Colors.blue[50] : Colors.red[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isAvailable ? 'Available' : 'Full',
                            style: TextStyle(
                              color: isAvailable ? Colors.green : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 6),
                            Text(
                              '₹${ride['pricePerSeat']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isAvailable
                                    ? Colors.black
                                    : Colors.grey[500],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                        Text(
                          'Details ▼',
                          style: TextStyle(
                            color: isAvailable ? Colors.blue : Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
