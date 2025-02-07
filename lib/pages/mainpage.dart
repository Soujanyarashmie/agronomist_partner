import 'package:agronomist_partner/backend/go_router.dart';
import 'package:agronomist_partner/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.yellow[50],
      body: Column(
        children: [
          SearchBarWidget(),
          SizedBox(height: 25),
          InkWell(
            onTap: () {
              print('tapped');
             context.push('/address');
            },
            child: ContainerWidget(
              imagePath: "assets/images/buyproduct.jpg", 
              label: "Buy Products"
            ),
          ),
          SizedBox(height: 30),
          InkWell(
            onTap: () {
            context.push('/homepage');
             
            },
            child: ContainerWidget(
              imagePath: "assets/images/sellproduct.jpg",
              label: "Sell Products"
            ),
          ),
        ],
      ),
    );
  }
}


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserData userData = UserData();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      child: AppBar(
        backgroundColor: Colors.green[100],
        elevation: 0,
        leading: Icon(Icons.location_on, color: Colors.brown[600]),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Home",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              "425, TG lakevista, begur, begu...",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
  InkWell(
    onTap: () {
      context.push('/profilemenu');
    },
    child: CircleAvatar(
      backgroundImage: NetworkImage(userData.imageUrl),
    ),
  ),
  SizedBox(width: 10),
]

      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search "Products"',
          prefixIcon: Icon(Icons.search, color: Colors.brown[600]),
          suffixIcon: Icon(Icons.mic, color: Colors.brown[600]),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class ContainerWidget extends StatelessWidget {
  final String imagePath;
  final String label;

  ContainerWidget({required this.imagePath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 350,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 5,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // decoration: BoxDecoration(
            //   color: Colors.white.withOpacity(0.2),
            //   borderRadius: BorderRadius.circular(10),
            // ),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.brown[600],
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
