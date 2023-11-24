import 'package:flutter/material.dart';
import 'package:playground/providers/dark_theme_provider.dart';

abstract class Style {
  static const backgroundColor = Color.fromARGB(255, 240, 240, 240);
  static const backgroundColorDark = Color.fromARGB(255, 32, 32, 32);
  static const foregroundColorDark = Color.fromARGB(255, 50, 50, 50);
  static const darkColorDark = Color.fromARGB(255, 20, 20, 20);
  static const primaryColor = Colors.blueAccent;
  static const primaryColorDark = Colors.redAccent;

  static const textColorGray = Color.fromARGB(255, 150, 150, 150);
  static const textColor = Color.fromARGB(255, 50, 50, 50);
  static const textColorWhite = Color.fromARGB(255, 240, 240, 240);
  static const textColorHint = Color.fromARGB(255, 180, 180, 180);
  static const textBoxBackgroundColor = Color.fromARGB(255, 245, 245, 245);
  static const shadowColor = Color.fromARGB(100, 0, 0, 0);

  ///Elevation for topbars, etc.
  static const double elevation = 2;
  static const double pagePadding = 10;
  static const double listSpacing = 5;
  static const double gridSpacing = 4;
  static const double lineSpacing = 20;
  static const double headerSpacing = 10;
  static const double textHeaderSize = 24;
  static const double textSubHeaderSize = 18;
  static const double textContentSize = 16;
  static const double textSize = 14;
  static const double textSmallSize = 12;
  static const double rounding = 10;
  static const LinearGradient gradient = LinearGradient(
    begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [Colors.lightBlueAccent, Colors.blueAccent, Colors.purpleAccent]
  );
  static const LinearGradient gradientDark = LinearGradient(
    begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [Colors.deepOrangeAccent, Colors.redAccent, Colors.purpleAccent]
  );
  static const TextStyle textStyle = TextStyle(color: Style.textColor, fontSize: Style.textContentSize, fontFamily: "Raleway", fontWeight: FontWeight.normal);

  ///For gridviews, if screen is wider than 500px it will display 3 items per row instead of 2
  static const int bigScreen = 500;
  static const double appbarHeight = 30;

  static const EdgeInsets padding =
      EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10);

  static TextStyle createTextStyle ({
    Color?  textColor = Style.textColor,
    double  fontSize = Style.textContentSize,
    String fontFamily = "Raleway",
    FontWeight fontWeight = FontWeight.normal,
  }) {
    textColor = textColor ?? (DarkThemeProvider.isDarkTheme ? Style.textColorWhite : Style.textColor);

    return TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight
      );
  }


  /*
  static TextStyle textStylewithBorder({
    
  }) {
    return TextStyle(
        fontSize: fontSize,
        color: color ?? (DarkThemeProvider.isDarkTheme ? Style.whiteTextColor : Style.textColor),
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        decorationStyle: decorationStyle,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.black);
  }
  */

  static String formatTime(DateTime time) {
    Duration difference = DateTime.now().difference(time);

    if (difference.inMinutes < 1) {
      return "Just now";
    }

    if (difference.inHours == 0) {
      if (difference.inMinutes == 1) {
        return "1 minute ago";
      }

      return "${difference.inMinutes} minutes ago";
    }

    if (difference.inDays < 1) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return "Yesterday ${time.hour}:${time.minute}";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }
}

