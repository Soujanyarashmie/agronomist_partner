import 'package:agronomist_partner/backend/go_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LowerBottomAppBar extends StatefulWidget {
  const LowerBottomAppBar({super.key});

  @override
  _LowerBottomAppBarState createState() => _LowerBottomAppBarState();
}

class _LowerBottomAppBarState extends State<LowerBottomAppBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      color: Colors.green[100],
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart,
                color: _selectedIndex == 0 ? Colors.brown[500] : Colors.white),
            onPressed: () => _onItemTapped(0),
          ),
          const SizedBox(width: 40), // Space for FAB
          IconButton(
            icon: Icon(Icons.shopping_cart,
                color: _selectedIndex == 1 ? Colors.brown[500] : Colors.white),
            onPressed: () {
              context.push('/listedproduct');
            }
          ),
        ],
      ),
    );
  }
}
