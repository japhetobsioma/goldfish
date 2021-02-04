import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _currentIndex = 0;

  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  static UnityWidgetController _unityWidgetController;

  static void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  final _widgetOptions = [
    Text('Home'),
    UnityWidget(
      onUnityCreated: onUnityCreated,
    ),
    Text('History'),
    Text('Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: const Color(0xFFE7EEFB),
        child: Center(
          child: _widgetOptions.elementAt(_currentIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 20.0,
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFFE7EEFB),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(.15),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Aquarium',
            icon: Icon(Icons.waves),
          ),
          BottomNavigationBarItem(
            label: 'History',
            icon: Icon(Icons.history_edu),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.local_drink),
              backgroundColor: const Color(0xFF0076FF),
            )
          : null,
    );
  }
}
