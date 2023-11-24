import 'package:flutter/material.dart';
import 'package:playground/globals/style.dart';

class GradientMask extends StatelessWidget {
  final Widget? child;
  final LinearGradient? gradient;

  const GradientMask({Key? key, 
    this.child,
    this.gradient
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: child,
      shaderCallback: (Rect bounds) => (gradient ?? Style.gradient).createShader(bounds)
    );
  }
}