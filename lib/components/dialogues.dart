import 'package:flutter/material.dart';
import 'package:playground/globals/style.dart';

class Dialogues {
  static void showNoticeDialogue(BuildContext context, {
      Text? title,
      Text? content,
      required Text footer,
      Color headerColor = Style.primaryColor,
      LinearGradient? headerGradient,
      Color contentColor = Style.backgroundColor,
      
      double borderRadius = 10,

      void Function()? onConfirm
    }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius)
          )
        ),
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: contentColor,
        title: Container(
          height: 50,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: headerColor,
            gradient: headerGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius)
            ),
          ),
          child: title ?? const Text("Notice", style: Style.textStyle)
        ),
        content: content ?? const Text("Something went wrong", style: Style.textStyle),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
            child: footer
          ),
        ],
      ),
    );
  }
}