import 'package:flutter/material.dart';
import 'package:playground/main.dart';
import 'package:playground/models/shared_preference_model.dart';

class DarkThemeProvider with ChangeNotifier {
  static bool isDarkTheme = false;

  bool getDark() {
    return isDarkTheme;
  }

  Future<void> setDark(bool value, [BuildContext? context]) async {
    isDarkTheme = value;

    SharedPreferencesModel.setDarkMode(value);

    notifyListeners();

     if (context != null) {
        MyApp.refresh(context);
      } 
  }

  static final DarkThemeProvider _singleton = DarkThemeProvider._internal();
  factory DarkThemeProvider() {
    return _singleton;
  }
  DarkThemeProvider._internal() {
    SharedPreferencesModel.getDarkMode().then((value) {
      isDarkTheme = value;
      notifyListeners();
    });
  }
}