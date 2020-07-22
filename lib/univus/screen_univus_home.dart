import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'tab_univus_home.dart';
import 'tab_univus_settings.dart';

class UnivusHomeScreenWidget extends StatefulWidget {
  @override
  _UnivusHomeScreenState createState() => _UnivusHomeScreenState();
}

class _UnivusHomeScreenState extends State<UnivusHomeScreenWidget> {
  int _currentIndex = 0;
  List<Widget> _children = [];

  @override
  void initState() {
    super.initState();

    _children = [
      UnivusHomeTabWidget(),
      UnivusSettingsTabWidget(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Chatbot',
        child: Icon(Icons.chat),
      ),
    );
  }
}
