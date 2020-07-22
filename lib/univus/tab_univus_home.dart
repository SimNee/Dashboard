import 'package:chatbot/storage_preferences.dart';
import 'package:flutter/material.dart';

class UnivusHomeTabWidget extends StatefulWidget {
  @override
  _UnivusHomeTabState createState() => _UnivusHomeTabState();
}

class _UnivusHomeTabState extends State<UnivusHomeTabWidget> {
  String _userid = '';

  @override
  void initState() {
    super.initState();
    _getUserid();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _getUserid() async {
    String userid = await getNusUserid();
    if (userid != null) {
      setState(() {
        _userid = userid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40.0,
          ),
          Text(
            'Hi $_userid,',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
