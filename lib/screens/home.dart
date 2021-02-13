import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const itemLabels = ['Home', 'Aquarium', 'History', 'Settings'];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Color(0xFF6200EE),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.6),
        selectedFontSize: 14,
        showUnselectedLabels: false,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: itemLabels[0],
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: itemLabels[1],
            icon: Icon(Icons.waves),
          ),
          BottomNavigationBarItem(
            label: itemLabels[2],
            icon: Icon(Icons.history),
          ),
          BottomNavigationBarItem(
            label: itemLabels[3],
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
