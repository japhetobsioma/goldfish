import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:flutter/material.dart';

import 'OutputScreen.dart';
import '../constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  // ignore: unused_field
  UnityWidgetController _unityWidgetController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: UnityWidget(
            onUnityCreated: onUnityCreated,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 4.0,
        color: kBackgroundColor,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              color: Colors.grey[900],
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: kBackgroundColor,
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.assessment),
                          title: const Text('Show Graph'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.timeline),
                          title: const Text('Show Timeline'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.tune),
                          title: const Text('Change Unit'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.local_cafe),
                          title: const Text('Change Cup'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.flag),
                          title: const Text('Change Water Goal'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              color: Colors.grey[900],
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: kBackgroundColor,
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.history_edu),
                          title: const Text('Show History'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.notifications),
                          title: const Text('Change Reminder'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.contact_page),
                          title: const Text('Change User Information'),
                          onTap: () {
                            showDialog<void>(
                                context: context,
                                builder: (context) => OutputScreen());
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.alarm),
                          title: const Text('Bedtime and Wake-Up Time'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Reset Application Data'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {},
        child: Icon(
          Icons.local_drink_rounded,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }
}
