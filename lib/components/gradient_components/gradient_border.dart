import 'package:flutter/material.dart';
import 'package:playground/components/rounded_background.dart';
import 'package:playground/globals/style.dart';

class GradientBorder extends StatelessWidget {
  final double borderRadius;
  final LinearGradient gradient;
  final double thickness;
  final RoundedBackground child;
  final double? width;
  final double? height;
  
  const GradientBorder({
    super.key,
    this.borderRadius = 50,
    this.gradient = Style.gradient,
    this.thickness = 4,
    required this.child,
    this.width,
    this.height
  });
  
  @override
  Widget build(BuildContext context) {
    return RoundedBackground(
      width: width,
      height: height,
      borderRadius: borderRadius,
      gradient: gradient,
      child: Padding(
        padding: EdgeInsets.all(thickness),
        child: child
      ),
    );
  } 
}