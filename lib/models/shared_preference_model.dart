import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesModel {
  static final Future<SharedPreferences> _sharedPref = SharedPreferences.getInstance();
  static const String storageKey = "PLAYGROUND/";

  static Future<bool> getDarkMode() async {
    return (await _sharedPref).getBool("${storageKey}DARKMODE") ?? false;
  }

  static Future<bool> setDarkMode(bool status) async {
    return (await _sharedPref).setBool("${storageKey}DARKMODE", status);
  }

  static Future<String> getLanguage() async {
    return (await _sharedPref).getString("${storageKey}LANGUAGE") ?? "en";
  }

  static Future<bool> setLanguage(String language) async {
    return (await _sharedPref).setString("${storageKey}LANGUAGE", language);
  }
}