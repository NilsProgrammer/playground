import 'package:flutter/material.dart';

import '../../globals/style.dart';

class GradientBackground extends StatelessWidget {
  final LinearGradient? gradient;
  final Widget? child;
  const GradientBackground({
    Key? key, this.gradient, this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: Style.elevation,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? Style.gradient
        ),
        child: child
      ),
    );
  }
}