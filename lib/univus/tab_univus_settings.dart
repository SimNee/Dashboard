import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UnivusSettingsTabWidget extends StatefulWidget {
  @override
  _UnivusSettingsTabState createState() => _UnivusSettingsTabState();
}

class _UnivusSettingsTabState extends State<UnivusSettingsTabWidget> {
  String userInput;
  String savedTimetable;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey.shade100,
                    hintText: 'Enter NUSMODS Timetable Link',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    userInput = value;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: RaisedButton(
                      color: Colors.orange.shade400,
                      onPressed: () {
                        _launchURL();
                      },
                      child: Text(
                        'NUSMODS',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: RaisedButton(
                      color: Colors.cyan.shade300,
                      onPressed: () {
                        _save();
                      },
                      child: Text(
                        'Save Timetable',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(100.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    savedTimetable ?? 'No timetable saved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_timetable_key';
    final String value = userInput;
    prefs.setString(key, value);
    print('saved $value');
    final readValue = prefs.getString(key) ?? 'No timetable saved.';
    setState(() {
      savedTimetable = readValue;
    });
  }

  _launchURL() async {
    const url = 'https://nusmods.com/timetable/sem-1';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
