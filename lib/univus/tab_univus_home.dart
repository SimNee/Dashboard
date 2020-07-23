import 'package:chatbot/storage_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

const nusmodURL = 'https://api.nusmods.com/v2';
const year = '2020-2021';

class UnivusHomeTabWidget extends StatefulWidget {
  @override
  _UnivusHomeTabState createState() => _UnivusHomeTabState();
}

class _UnivusHomeTabState extends State<UnivusHomeTabWidget> {
  String _userid = '';
  String savedTimetable;
  String semester;
  String todayDate;
  List list = new List();
  List infoList = new List();

  @override
  void initState() {
    super.initState();
    _getUserid();
    _getTodayDate();
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hi $_userid,',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
//            Container(
//              margin: EdgeInsets.all(20),
//              decoration: BoxDecoration(
//                color: Colors.blueGrey.shade50,
//                shape: BoxShape.rectangle,
//                borderRadius: BorderRadius.all(
//                  Radius.circular(25.0),
//                ),
//              ),
//              child: Padding(
//                padding: const EdgeInsets.all(20),
//                child: Text(
//                  savedTimetable ?? 'No timetable saved.',
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                    fontSize: 15.0,
//                  ),
//                ),
//              ),
//            ),
            Container(
              child: Text(
                todayDate ?? "Date",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              semester ?? "Error",
            ),
            SizedBox(
              width:
                  MediaQuery.of(context).size.width * .8, // 80% of the screen
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: list.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return Ink(
                    color: Colors.amber,
                    child: ListTile(
                      title: Text(
                        list[index].toString(),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width:
                  MediaQuery.of(context).size.width * .8, // 80% of the screen
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: infoList.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return Ink(
                    color: Colors.teal,
                    child: ListTile(
                      title: Text(
                        infoList[index].toString(),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_timetable_key';
    final value = prefs.getString(key) ?? 'Unable to read timetable.';
    setState(() {
      savedTimetable = value;
    });
    print('reading timetable');
    if (savedTimetable != null &&
        savedTimetable != 'No timetable saved.' &&
        savedTimetable != 'Unable to read timetable.') {
      try {
        await _processTimetable(savedTimetable);
      } catch (err) {
        print('Caught error: $err');
      }
    }
  }

  Future<List<dynamic>> _processTimetable(String string) async {
    String url = string.trim().split("?").sublist(0, 1).first;
    //print(url);

    semester = url.split("/").sublist(4, 5).first;
    //print('Semester: $semester');

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
      //print('$moduleSplit');
      moduleInfo.add(moduleCode);
      moduleMap["classNo"] = "$moduleCode";
      //print(moduleMap["classNo"]);
      //print('moduleCode: $moduleCode');
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
      //print(moduleMap);
      list.add(moduleMap);
    }
    //print(list);
    try {
      await _getModuleData();
    } catch (err) {
      print('Caught error: $err');
    }
    return list;
  }

  Future<List<dynamic>> _getModuleData() async {
    for (var item in list) {
      //print(item);
      var moduleCode = item["classNo"];
      //print(moduleCode);
      Map<String, dynamic> infoMap = {};
      infoMap["classNo"] = moduleCode;
      http.Response response =
          await http.get('$nusmodURL/$year/modules/$moduleCode.json');
      if (response.statusCode == 200) {
        int index;
        if (semester == 'sem-1') {
          index = 0;
        } else if (semester == 'sem-2') {
          index = 1;
        } else if (semester == 'st-i') {
          index = 2;
        } else if (semester == 'st-ii') {
          index = 3;
        }

        var data = response.body;
        //print(data);
        var examDate = jsonDecode(data)["semesterData"][index]["examDate"];
        //print(examDate);
        infoMap["examDate"] = examDate;
        //print(infoMap);
        infoList.add(infoMap);
        var timetable = jsonDecode(data)["semesterData"][index]["timetable"];
      } else {
        print(response.statusCode);
      }
    }
    print(infoList);
    return infoList;
  }

  void _getTodayDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMM d, y');
    final String formatted = formatter.format(now);
    //print(formatted);
    todayDate = formatted;
  }
}
