import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomAppBarNav extends StatefulWidget {
  final Widget child;
  const BottomAppBarNav({super.key, required this.child});

  @override
  State<BottomAppBarNav> createState() => _BottomAppBarNavState();
}

class _BottomAppBarNavState extends State<BottomAppBarNav> {
  int _selectedIndex = 0;

  final List<String> _routes = [
    '/mainpage',
    '/publish',
    '/rides',
    '/inbox',
    '/profile',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouter.of(context).routeInformationProvider.value.location;
    final index = _routes.indexWhere((route) => location.startsWith(route));
    if (index != -1 && index != _selectedIndex) {
      _selectedIndex = index;
    }
  }

  void _onItemTapped(int index) {
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Scaffold background color
      body: widget.child,
     bottomNavigationBar: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    // Move line down using Padding or increase margin
    Padding(
      padding: const EdgeInsets.only(top: 8.0), // Moves it down from top
      child: Container(
        height: 1,
        color: Colors.grey.shade300,
      ),
    ),
    Theme(
      data: ThemeData(
        canvasColor: Colors.white,
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF1B4EA0),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Publish'),
          BottomNavigationBarItem(icon: Icon(Icons.format_quote), label: 'Your rides'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    ),
  ],
),

    );
  }
}
