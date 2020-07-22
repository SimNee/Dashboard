import 'package:flutter/material.dart';

import 'univus/screen_univus_login.dart';

class UnivusApp extends StatefulWidget {
  @override
  _UnivusAppState createState() => _UnivusAppState();
}

class _UnivusAppState extends State<UnivusApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'uNivUS App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UnivusLoginScreenWidget(
        key: globalKeyUnivusLoginScreenState,
      ),
    );
  }
}
