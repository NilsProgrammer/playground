import 'package:flutter/material.dart';
import 'package:playground/globals/style.dart';
import 'package:playground/providers/dark_theme_provider.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: DarkThemeProvider.isDarkTheme
            ? Style.backgroundColorDark
            : Style.backgroundColor,

        body: Container());
  }
}