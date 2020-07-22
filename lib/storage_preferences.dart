import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _preferences;

Future<SharedPreferences> _getSharedPreferences() async {
  if (_preferences == null) {
    _preferences = await SharedPreferences.getInstance();
  }
  return _preferences;
}

Future<String> getNusUserid() async {
  await _getSharedPreferences();
  if (_preferences != null) {
    return _preferences.getString('univus_userid');
  } else {
    return '';
  }
}

Future<void> setNusUserid(String userid) async {
  await _getSharedPreferences();
  if (_preferences != null) {
    _preferences.setString('univus_userid', userid);
  }
}
