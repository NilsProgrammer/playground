import 'package:flutter/material.dart';
import 'package:playground/components/rotating_widget.dart';
import 'package:playground/globals/style.dart';
import 'package:playground/providers/dark_theme_provider.dart';

import '../components/gradient_components/gradient_circular_progress_indicator.dart';
import '../components/gradient_components/gradient_background.dart';

class LoadingPage extends StatefulWidget {
  final LinearGradient? gradient;
  final Color? foregroundColor;

  const LoadingPage({
    Key? key,
    this.gradient,
    this.foregroundColor

  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Center(
          child: RotatingWidget(
              child: GradientCircularProgressIndicator(
                radius: 50,
                gradientColors: DarkThemeProvider.isDarkTheme ? Style.gradientDark.colors : Style.gradient.colors,
                strokeWidth: 5.0,
              ),
            ),
        )
      )
    );
  }
}