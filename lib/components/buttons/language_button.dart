import 'package:flutter/material.dart';
import 'package:playground/providers/language_provider.dart';

class LanguageButton extends StatefulWidget {
  final Color? backgroundColor;
  final void Function()? onPressed;

  const LanguageButton({Key? key, this.onPressed, this.backgroundColor}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Language>(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      dropdownColor: widget.backgroundColor,
      elevation: 0,
      value: LanguageProvider.currentLanguage,
      underline: const SizedBox.shrink(),
      icon: const SizedBox.shrink(),
      onChanged: (value) {
        if (value == null) {return;}
        LanguageProvider().setLanguage(value).then((value) {
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        });
      },
      /* icon: Image.asset(
        "assets/flags/${LanguageProvider().getLanguage().flag}.png",
        height: 30, width: 30
      ), */
      items: languages.values.map((e) {
        return DropdownMenuItem<Language>(
          value: e,
          alignment: AlignmentDirectional.center,
          child: Image.asset(
            "assets/flags/${e.flag}.png",
            height: 30, width: 30
          )
        );
      }).toList(),
    );
  }
  
}