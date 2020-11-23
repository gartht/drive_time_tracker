import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<T> getPreference<T>(String prefName) async {
    SharedPreferences sp = await _prefs;

    if (sp.containsKey(prefName)) {
      try {
        return sp.get(prefName) as T;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<void> setPreference<T>(String prefName, T value) async {
    SharedPreferences sp = await _prefs;

    switch (T) {
      case int:
        sp.setInt(prefName, value as int);
        break;
      case String:
        sp.setString(prefName, value as String);
        break;
      case bool:
        sp.setBool(prefName, value as bool);
        break;
      case double:
        sp.setDouble(prefName, value as double);
        break;
    }
  }
}
