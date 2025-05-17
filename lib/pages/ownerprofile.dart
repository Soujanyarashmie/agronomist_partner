import 'package:flutter/material.dart';

class DriverProfilePage extends StatefulWidget {
  final Map<String, dynamic> ride;

  const DriverProfilePage({super.key, required this.ride});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  late Map<String, dynamic> driver;

  @override
  void initState() {
    super.initState();
    print('Ride data: ${widget.ride}');

    driver = widget.ride['user'] ?? {};
  }

  String getExperienceLevel() {
    final createdAtString = driver['createdAt'];
    if (createdAtString == null) return 'N/A';

    final createdAt = DateTime.tryParse(createdAtString);
    if (createdAt == null) return 'N/A';

    final now = DateTime.now();
    final months = (now.difference(createdAt).inDays / 30).floor();

    if (months < 1) return 'New Joiner';
    if (months < 3) return 'Intermediate';
    return 'Experienced';
  }

  @override
  Widget build(BuildContext context) {
    final photo = driver['photoUrl'] ?? driver['photoURL'];
    final name = driver['name'] ?? 'Unknown';
    final age = driver['age'] != null ? '${driver['age']} y/o' : '';
    final about = (driver['aboutUser'] as List?)?.join(", ") ?? '';
    final email = driver['email'];
    final phone = driver['phone'];
    final createdAt = driver['createdAt'] != null
        ? DateTime.tryParse(driver['createdAt']) ?? DateTime.now()
        : DateTime.now();
    final memberSince = "${_monthName(createdAt.month)} ${createdAt.year}";

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: photo != null ? NetworkImage(photo) : null,
                      child: photo == null
                          ? const Icon(Icons.person, size: 40, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.verified, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      if (age.isNotEmpty)
                        Text(age, style: const TextStyle(color: Colors.grey)),
                      if (about.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(about,
                              style: const TextStyle(fontSize: 15, color: Colors.black87)),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Experience
            Text(
              'Experience level: ${getExperienceLevel()}',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),

            // Verifications
            const Text(
              'Driver has a Verified Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (email != null && email.toString().isNotEmpty)
              const VerificationRow(label: 'Confirmed email'),
            if (phone != null && phone.toString().isNotEmpty)
              const VerificationRow(label: 'Confirmed phone number'),

            const Divider(height: 32),

            // Footer
            const Text(
              'No published and completed rides',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Member since $memberSince',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '', // padding for index
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
}

// Helper widget for Verification rows
class VerificationRow extends StatelessWidget {
  final String label;
  const VerificationRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.verified, size: 16, color: Colors.blue),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
