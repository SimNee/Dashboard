import 'package:chatbot/storage_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnivusHomeTabWidget extends StatefulWidget {
  @override
  _UnivusHomeTabState createState() => _UnivusHomeTabState();
}

class _UnivusHomeTabState extends State<UnivusHomeTabWidget> {
  String _userid = '';
  String savedTimetable;
  List list = new List();

  @override
  void initState() {
    super.initState();
    _getUserid();
    _read();
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
          Container(
            margin: EdgeInsets.all(20),
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
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 800,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return new Text(list[index].toString());
              },
            ),
          ),
        ],
      ),
    );
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_timetable_key';
    final value = prefs.getString(key) ?? 'Unable to read timetable.';
    setState(() {
      savedTimetable = value;
    });
    print('read');
    if (savedTimetable != null &&
        savedTimetable != 'No timetable saved.' &&
        savedTimetable != 'Unable to read timetable.') {
      _processTimetable(savedTimetable);
    }
  }

  List<dynamic> _processTimetable(String string) {
    String url = string.trim().split("?").sublist(0, 1).first;
    //print(url);

    var semester = url.split("/").sublist(4, 5).first;
    print('$semester');

    var data = string.split("?").sublist(1, 2).first;
    //print(data);

    var listOfModules = data.split("&");
    //print(listOfModules);

    for (String module in listOfModules) {
      List moduleInfo = [];
      Map<String, String> moduleMap = {};
      var moduleSplit = module.split("=");
      var moduleCode = moduleSplit.first;
      var slots = module.split("=").sublist(1, 2).first.split(",");
      //print('\n$moduleSplit');
      moduleInfo.add(moduleCode);
      moduleMap["classNo"] = "$moduleCode";
      //print(moduleMap["classNo"]);
      //print('  moduleCode: $moduleCode');
      //print(slots);

      for (String slot in slots) {
        var s = slot.split(":");
        moduleInfo.add(s);
        if (s.first == "TUT") {
          moduleMap["TUT"] = s.sublist(1).first;
          //print('TUT: ${moduleMap["TUT"]}');
        } else if (s.first == "LEC") {
          moduleMap["LEC"] = s.sublist(1).first;
          //print('LEC: ${moduleMap["LEC"]}');
        } else if (s.first == "SEC") {
          moduleMap["SEC"] = s.sublist(1).first;
          //print('SEC: ${moduleMap["SEC"]}');
        } else if (s.first == "REC") {
          moduleMap["REC"] = s.sublist(1).first;
          //print('REC: ${moduleMap["REC"]}');
        } else if (s.first == "LAB") {
          moduleMap["LAB"] = s.sublist(1).first;
          //print('LAB: ${moduleMap["LAB"]}');
        }
      }
      //print(moduleInfo);
      //list.add(moduleInfo);
      print(moduleMap);
      list.add(moduleMap);
    }
    print(list);
    return list;
  }
}
