
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screen_univus_home.dart';
import '../storage_preferences.dart';

final GlobalKey<_UnivusLoginScreenState> globalKeyUnivusLoginScreenState =
    GlobalKey<_UnivusLoginScreenState>();

class UnivusLoginScreenWidget extends StatefulWidget {
  UnivusLoginScreenWidget({Key key}) : super(key: key);

  @override
  _UnivusLoginScreenState createState() => _UnivusLoginScreenState();
}

class _UnivusLoginScreenState extends State<UnivusLoginScreenWidget> {
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _navigateToHomeScreenContext(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UnivusHomeScreenWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        TextField(
          controller: textEditingController,
        ),
        RaisedButton(
          child: Text('LOG IN'),
          onPressed: () {
            String userid = textEditingController.text;
            setNusUserid(userid);
            _navigateToHomeScreenContext(context);
          },
        ),
      ]),
    );
  }
}
