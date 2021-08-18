import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtil {
  static SharedPreferences prefs;
  static const String SP_IS_FETCH_DATA = 'SP_IS_FETCH_DATA';


  static Future initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> getBool(String spKey) async {
    prefs??await initialize();
    return prefs.containsKey(spKey)
        ? prefs.getBool(spKey)
        : false;
  }

  static Future<bool> putBool(String spKey, bool value) async {
    prefs??await initialize();
    return await prefs.setBool(spKey, value);
  }

  static Future<String> getString(String spKey) async {
    prefs??await initialize();
    return prefs.containsKey(spKey) ? prefs.getString(spKey) : '';
  }

  static Future<bool> putString(String spKey, String value) async {
    prefs??await initialize();
    return await prefs.setString(spKey, value);
  }

  static Future<int> getInt(String spKey) async {
    prefs??await initialize();
    return prefs.containsKey(spKey)
        ? prefs.getInt(spKey)
        : 0;
  }

  static Future<bool> putInt(String spKey, int value) async {
    prefs??await initialize();
    return await prefs.setInt(spKey, value);
  }

}

