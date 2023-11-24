import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground/models/shared_preference_model.dart';

const defaultLanguage = Language(countryCode: "us", name: "English", languageCode: "en", flag: "en");
  ///Languages currently supported, [key] == [languageCode]
const Map<String, Language> languages = {
  "en" : defaultLanguage,
  "de" : Language(countryCode: "de", name: "Germany", languageCode: "de", flag: "de"),
};

class LanguageProvider extends ChangeNotifier {
  static Language currentLanguage = defaultLanguage;

  static String translate(String key) {
    return LanguageProvider()._translationMap[key] ?? key;
  }
  final Map<String, String> _translationMap = {};

  Future<void> _load(Language language) async {
    String jsonStringValues = await rootBundle.loadString('assets/translations/${language.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _translationMap.clear();
    _translationMap.addAll(mappedJson.map((key, value) => MapEntry(key, value.toString())));
  }

  Language getLanguage() {
    return currentLanguage;
  }

  Future<void> setLanguage(Language value, [BuildContext? context]) async {
    currentLanguage = value;

    SharedPreferencesModel.setLanguage(value.languageCode);
    
    await _load(currentLanguage);

    notifyListeners();
  }
  
  static final LanguageProvider _singleton = LanguageProvider._internal();
  factory LanguageProvider() {
    return _singleton;
  }
  LanguageProvider._internal() {
    SharedPreferencesModel.getLanguage().then((value) {
      currentLanguage = Language.fromLocaleString(value);
      _load(currentLanguage).then((value) => notifyListeners());
    });
  }
}

class Language {
  ///See [Locale]>[countryCode]
  final String countryCode;
  ///For user display
  final String name;

  final String languageCode;
  ///Flag image name inside assets
  final String flag;

  const Language({
    required this.countryCode,
    required this.name,
    required this.languageCode,
    required this.flag
  });

  static Language fromLocale(Locale locale) {
    return languages[locale.languageCode] ?? defaultLanguage;
  }

  static Language fromLocaleString(String locale) {
    return languages[locale] ?? defaultLanguage;
  }

  Locale toLocale() {
    return Locale(languageCode, countryCode);
  }
}