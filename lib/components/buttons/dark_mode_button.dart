import 'package:flutter/material.dart';
import 'package:playground/globals/style.dart';
import 'package:playground/providers/dark_theme_provider.dart';

class DarkModeButton extends StatefulWidget {
  final void Function()? onPressed;
  const DarkModeButton({
    this.onPressed,
    super.key
  });

  @override
  State<StatefulWidget> createState() => _DarkModeButtonState();
}

class _DarkModeButtonState extends State<DarkModeButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          DarkThemeProvider().setDark(!DarkThemeProvider.isDarkTheme);
          if (widget.onPressed != null) {widget.onPressed!();}
        });
      },
      icon: DarkThemeProvider.isDarkTheme ? const Icon(
        Icons.dark_mode_rounded,
        color: Style.backgroundColor,
      ) : const Icon(
        Icons.light_mode_rounded,
      )
    );
  }

}