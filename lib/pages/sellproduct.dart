
import 'package:agronomist_partner/components/bottomappbar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';

class Sellproduct extends StatelessWidget {
  final List<String> imageUrls = [
    'assets/images/honey.jpg',
    'assets/images/cotton.jpg',
    'assets/images/mills.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sell Product',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.green[100],
      ),
      body: Container(
        color: Colors.yellow[50], // Set the color for the entire body background
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 190,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0, // Ensures images stretch to fill the space
              ),
              items: imageUrls.map((url) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(url,
                        fit: BoxFit.cover, width: double.infinity),
                  ),
                );
              }).toList(),
            ),
          Expanded(
  child: Container(
    alignment: Alignment.topLeft, // Aligns the child to the top left
    padding: EdgeInsets.all(10.0), // Add padding around the content
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start of the column (left)
      children: [
        Text(
          "List Your Products",
          style: TextStyle(
            fontSize: 17.0, // Adjust the font size as needed
            fontWeight: FontWeight.w500, // Set the font weight to medium
            color: Colors.black, // Set the text color to black
          ),
        ),
        SizedBox(height: 5,),
        Divider(color:Colors.grey[300],),
        // Space between text and image
        GestureDetector(
  onTap: () {
    context.push('/productupload');
    // Handle the tap event here
    print('Image Tapped!'); // Example action: printing to console
  },
  child: Image.asset(
    'assets/images/addmore1.png', // Ensure this path is correct
    width: 100,
    height: 100,
  ),
)

      ],
    ),
  ),
)

          ],
        ),
      ),
      bottomNavigationBar: const LowerBottomAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/sellproduct');
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
